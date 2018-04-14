# Handles for Opened, Reoped and Edited
module Webhooks
  class HandlePullRequestActionOpened
    include Interactor
    include InteractorHelpers

    def_delegators :context, :payload, :access_token

    def call
      each_fixable_issue(payload['pull_request']['body']) do |id|
        issue = client.issue(repo_full_name, id)

        action = payload['action']

        client.add_assignees(repo_full_name, id, [payload['pull_request']['user']['login']])
        add_in_progress(issue)
        body = add_pr_reference(action, issue)

        next unless body

        client.update_issue(repo_full_name, id, issue['title'], body)
      end
    end

    private

    def add_in_progress(issue)
      return if issue['labels'].any? { |label| label['name'] == Constants::READY_FOR_REVIEW }

      id = issue['number']

      add_label_to_an_issue(
        id,
        Constants::IN_PROGRESS
      )
    end

    def pr_number
      payload['pull_request']['number']
    end

    def add_pr_reference(action, issue)
      body = issue['body'].to_s

      body.gsub!("<strike>**PR:** ##{pr_number}</strike>", '') if action == 'reopened'

      return if body.include?("**PR:** ##{pr_number}")

      body += "\n" unless body.include?('**PR:**')

      body + "\n**PR:** ##{pr_number}"
    end
  end
end
