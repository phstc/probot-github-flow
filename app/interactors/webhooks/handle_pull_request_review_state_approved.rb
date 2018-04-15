module Webhooks
  class HandlePullRequestReviewStateApproved
    include Interactor
    include InteractorHelper

    def_delegators :context, :payload

    def call
      each_fixable_issue(payload['pull_request']['body']) do |number|
        remove_label(
          number,
          [Constants::REVIEW_REQUESTED, Constants::REJECTED]
        )
      end
    end
  end
end
