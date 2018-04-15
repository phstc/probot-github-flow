module Webhooks
  class HandlePullRequestActionClosed
    include Interactor
    include InteractorHelper

    def_delegators :context, :payload, :repo_full_name

    def call
      each_fixable_issue(payload['pull_request']['body']) do |number|
        issue = client.issue(repo_full_name, number)

        body = remove_pr_reference(issue)

        next unless body

        close_referenced_issues(number) if payload['pull_request']['merged'].to_s == 'true'
        client.update_issue(repo_full_name, number, issue['title'], body)
      end
    end

    private

    def pr_number
      payload['pull_request']['number']
    end

    def close_referenced_issues(number)
      client.close_issue(repo_full_name, number)

      remove_label(
        number,
        [Constants::IN_PROGRESS, Constants::READY_FOR_REVIEW, Constants::REVIEW_REQUESTED, Constants::REJECTED]
      )
    end

    def remove_pr_reference(issue)
      body = issue['body'].to_s
      body.gsub("**PR:** ##{pr_number}", "<strike>**PR:** ##{pr_number}</strike>")
    end
  end
end
