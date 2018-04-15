module Webhooks
  class HandlePullRequestReviewStateChangesRequested
    include Interactor
    include InteractorHelper

    def_delegators :context, :payload

    def call
      each_fixable_issue(payload['pull_request']['body']) do |number|
        add_labels_to_an_issue(
          number,
          Constants::REJECTED
        )
      end
    end
  end
end
