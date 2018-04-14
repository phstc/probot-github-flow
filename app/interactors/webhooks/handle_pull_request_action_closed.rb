module Webhooks
  class HandlePullRequestActionClosed
    include Interactor
    include InteractorHelpers

    def_delegators :context, :payload

    def call
      number = payload['pull_request']['number']

      Webhooks::FindFixableIssues.call!(payload['pull_request']['body']).ids.each do |id|
        issue = client.issue(repo_full_name, id)

        body = remove_pr_reference(number, issue)

        next unless body

        close_referenced_issues(id) if payload['pull_request']['merged'].to_s == 'true'
        client.update_issue(repo_full_name, id, issue['title'], body)
      end
    end

    private

    def close_referenced_issues(id)
      client.close_issue(repo_full_name, id)

      RemoveLabel.call!(
        repo_full_name: repo_full_name,
        id: id,
        label: [Constants::IN_PROGRESS, Constants::READY_FOR_REVIEW, Constants::REVIEW_REQUESTED, Constants::REJECTED]
      )
    end

    def remove_pr_reference(number, issue)
      body = issue['body'].to_s
      body.gsub("**PR:** ##{number}", "<strike>**PR:** ##{number}</strike>")
    end
  end
end
