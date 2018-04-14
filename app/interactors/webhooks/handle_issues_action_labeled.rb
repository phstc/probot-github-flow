module Webhooks
  class HandleIssuesActionLabeled
    include Interactor
    include InteractorHelpers

    def_delegators :context, :payload

    def call
      id = payload['issue']['number']

      case payload.dig('label', 'name')
      when Constants::READY_FOR_REVIEW
        remove_label(id, Constants::IN_PROGRESS)
      when Constants::REJECTED
        remove_label(id, [Constants::IN_PROGRESS, Constants::READY_FOR_REVIEW])
      when Constants::REVIEW_REQUESTED
        remove_label(id, Constants::IN_PROGRESS)
        add_label_to_an_issue(id, Constants::READY_FOR_REVIEW)
      end
    end
  end
end
