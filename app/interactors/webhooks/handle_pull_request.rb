module Webhooks
  class HandlePullRequest
    include Interactor
    include InteractorHelpers

    def_delegators :context, :payload, :access_token

    def call
      executor = case payload['action']
                 when 'closed'
                   HandlePullRequestActionClosed
                 when 'opened', 'edited', 'reopened'
                   update_referenced_issues_desc(payload)
                   nil
                 when 'review_requested'
                   HandlePullRequestActionReviewRequested
                 end

      executor&.call!(payload: payload, repo_full_name: repo_full_name, access_token: access_token)
    end

    private

    def update_referenced_issues_desc(payload)
      number = payload['pull_request']['number']

      each_fixable_issue(payload['pull_request']['body']) do |id|
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

      add_label_to_an_issue(
        id,
        Constants::IN_PROGRESS
      )
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
