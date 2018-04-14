module Webhooks
  class HandlePullRequestActionReviewRequested
    include Interactor
    include InteractorHelpers

    def_delegators :context, :payload

    def call
      Webhooks::FindFixableIssues.call!(payload['pull_request']['body']).ids.each do |id|
        AddLabelToAnIssue.call!(repo_full_name: repo_full_name, id: id, label: Constants::REVIEW_REQUESTED)
      end
    end
  end
end
