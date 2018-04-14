module Webhooks
  class HandlePullRequestReviewStateChangeRequested
    include Interactor
    include InteractorHelpers

    def_delegators :context, :payload

    def call
      each_fixable_issue(payload['pull_request']['body']) do |id|
        add_label_to_an_issue(id, Constants::REVIEW_REQUESTED)
      end
    end
  end
end
