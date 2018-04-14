module Webhooks
  class HandlePullRequest
    include Interactor
    include InteractorHelpers

    def_delegators :context, :payload

    def call
      case payload['action']
      when 'closed'
        HandlePullRequestActionClosed.call!(payload: payload)
      when 'opened', 'edited', 'reopened'
        update_referenced_issues_desc(payload)
      when 'review_requested'
        HandlePullRequestActionReviewRequested.call!(payload: payload)
      end
    end

    private

    def update_referenced_issues_desc(payload)
      number = payload['pull_request']['number']

      Webhooks::FindFixableIssues.call!(payload['pull_request']['body']).ids.each do |id|
        issue = client.issue(repo_full_name, id)

        action = payload['action']

        client.add_assignees(repo_full_name, id, [payload['pull_request']['user']['login']])
        add_in_progress(issue)
        body = add_pr_reference(action, number, issue)

        next unless body

        client.update_issue(repo_full_name, id, issue['title'], body)
      end
    end

    def add_in_progress(issue)
      return if issue['labels'].any? { |label| label['name'] == Constants::READY_FOR_REVIEW }

      id = issue['number']

      AddLabelToAnIssue.call!(repo_full_name: repo_full_name, id: id, label: Constants::IN_PROGRESS)
    end

    def add_pr_reference(action, number, issue)
      body = issue['body'].to_s

      body.gsub!("<strike>**PR:** ##{number}</strike>", '') if action == 'reopened'

      return if body.include?("**PR:** ##{number}")

      body += "\n" unless body.include?('**PR:**')

      body + "\n**PR:** ##{number}"
    end
  end
end
