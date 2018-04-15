module Webhooks
  class HandleIssuesActionLabeled
    include Interactor
    include InteractorHelper

    def_delegators :context, :payload

    def call
      number = payload['issue']['number']

      case payload.dig('label', 'name')
      when Constants::READY_FOR_REVIEW
        remove_label(number, Constants::IN_PROGRESS)
      when Constants::REJECTED
        remove_label(number, [Constants::IN_PROGRESS, Constants::READY_FOR_REVIEW])
      when Constants::REVIEW_REQUESTED
        remove_label(number, Constants::IN_PROGRESS)
        add_labels_to_an_issue(number, Constants::READY_FOR_REVIEW)
      end
    end
  end
end
