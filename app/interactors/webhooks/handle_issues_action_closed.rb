module Webhooks
  class HandleIssuesActionClosed
    include Interactor
    include InteractorHelpers

    def_delegators :context, :payload

    def call
      id = payload['issue']['number']

      remove_label(
        id,
        [Constants::IN_PROGRESS, Constants::READY_FOR_REVIEW, Constants::REVIEW_REQUESTED]
      )
    end
  end
end
