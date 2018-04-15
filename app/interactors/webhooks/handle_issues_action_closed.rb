module Webhooks
  class HandleIssuesActionClosed
    include Interactor
    include InteractorHelper

    def_delegators :context, :payload

    def call
      remove_label(
        payload['issue']['number'],
        [Constants::IN_PROGRESS, Constants::READY_FOR_REVIEW, Constants::REVIEW_REQUESTED]
      )
    end
  end
end
