module Webhooks
  class HandlePullRequestActionReviewRequested
    include Interactor
    include InteractorHelpers

    def_delegators :context, :payload, :repo_full_name, :access_token

    def call
      Webhooks::FindFixableIssues.call!(body: payload['pull_request']['body']).ids.each do |id|
        AddLabelToAnIssue.call!(
          repo_full_name: repo_full_name,
          id: id,
          label: Constants::REVIEW_REQUESTED,
          access_token: access_token
        )
      end
    end
  end
end
