module Webhooks
  class HandlePullRequest
    include Interactor
    include InteractorHelpers

    def_delegators :context, :payload

    def call
      if %w[opened edited closed reopened].include?(payload['action'])
        update_referenced_issues_desc(payload)

        close_referenced_issues(payload) if payload['action'] == 'closed' && payload['pull_request']['merged'].to_s == 'true'
      elsif payload['action'] == 'review_requested'
        review_requested(payload)
      end
    end

    private

    def update_referenced_issues_desc(payload)
      number = payload['pull_request']['number']

      Webhooks::FindFixableIssues.call!(payload['pull_request']['body']).ids.each do |id|
        issue = client.issue(repo_full_name, id)

        action = payload['action']

        body = \
          if action == 'closed'
            remove_pr_reference(number, issue)
          else
            client.add_assignees(repo_full_name, id, [payload['pull_request']['user']['login']])
            add_in_progress(issue)
            add_pr_reference(action, number, issue)
          end

        next unless body

        client.update_issue(repo_full_name, id, issue['title'], body)
      end
    end

    def add_in_progress(issue)
      return if issue['labels'].any? { |label| label['name'] == Constants::READY_FOR_REVIEW }

      id = issue['number']

      AddLabelToAnIssue.call!(repo_full_name: repo_full_name, id: id, label: Constants::IN_PROGRESS)
    end

    def close_referenced_issues(payload)
      Webhooks::FindFixableIssues.call!(payload['pull_request']['body']).ids.each do |id|
        client.close_issue(repo_full_name, id)

        RemoveLabel.call!(
          repo_full_name: repo_full_name,
          id: id,
          label: [Constants::IN_PROGRESS, Constants::READY_FOR_REVIEW, Constants::REVIEW_REQUESTED, Constants::REJECTED]
        )
      end
    end

    def remove_pr_reference(number, issue)
      body = issue['body'].to_s
      body.gsub("**PR:** ##{number}", "<strike>**PR:** ##{number}</strike>")
    end

    def add_pr_reference(action, number, issue)
      body = issue['body'].to_s

      body.gsub!("<strike>**PR:** ##{number}</strike>", '') if action == 'reopened'

      return if body.include?("**PR:** ##{number}")

      body += "\n" unless body.include?('**PR:**')

      body + "\n**PR:** ##{number}"
    end

    def review_requested(payload)
      Webhooks::FindFixableIssues.call!(payload['pull_request']['body']).ids.each do |id|
        AddLabelToAnIssue.call!(repo_full_name: repo_full_name, id: id, label: Constants::REVIEW_REQUESTED)
      end
    end
  end
end
