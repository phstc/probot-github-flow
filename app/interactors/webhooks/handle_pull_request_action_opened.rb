# Handles for Opened, Reoped and Edited
module Webhooks
  class HandlePullRequestActionOpened
    include Interactor
    include InteractorHelper

    def_delegators :context, :payload, :access_token, :repo_full_name

    def call
      each_fixable_issue(payload['pull_request']['body']) do |number|
        issue = client.issue(repo_full_name, number)

        action = payload['action']

        client.add_assignees(repo_full_name, number, [payload['pull_request']['user']['login']])
        add_in_progress_label(issue)
        body = add_pr_reference(action, issue)

        next unless body

        client.update_issue(repo_full_name, number, issue['title'], body)
      end
    end

    private

    def add_in_progress_label(issue)
      return if issue['labels'].any? { |label| label['name'] == Constants::READY_FOR_REVIEW }

      add_label_to_an_issue(
        issue['number'],
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
