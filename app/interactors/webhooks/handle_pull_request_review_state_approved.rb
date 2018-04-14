module Webhooks
  class HandlePullRequestReviewStateApproved
    include Interactor
    include InteractorHelpers

    def_delegators :context, :payload

    def call
      each_fixable_issue(payload['pull_request']['body']) do |id|
        remove_label(
          id,
          [Constants::REVIEW_REQUESTED, Constants::REJECTED]
        )
      end
    end
  end
end
