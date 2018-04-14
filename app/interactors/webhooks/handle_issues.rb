module Webhooks
  class HandleIssues
    include Interactor
    include InteractorHelpers

    def_delegators :context, :payload

    def call
      id = payload['issue']['number']

      case payload['action']
      when 'labeled'
        handle_labeled(id)
      when 'closed'
        handle_closed(id)
      end
    end

    private

    def handle_labeled(id)
      case payload.dig('label', 'name')
      when Constants::READY_FOR_REVIEW
        RemoveLabel.call!(repo_full_name: repo_full_name, id: id, label: Constants::IN_PROGRESS)
      when Constants::REJECTED
        RemoveLabel.call!(
          repo_full_name: repo_full_name,
          id: id,
          label: [Constants::IN_PROGRESS, Constants::READY_FOR_REVIEW]
        )
      when Constants::REVIEW_REQUESTED
        RemoveLabel.call!(repo_full_name: repo_full_name, id: id, label: Constants::IN_PROGRESS)
        AddLabelToAnIssue.call!(repo_full_name: repo_full_name, id: id, label: Constants::READY_FOR_REVIEW)
      end
    end

    def handle_closed(id)
      RemoveLabel.call!(
        repo_full_name: repo_full_name,
        id: id,
        label: [Constants::IN_PROGRESS, Constants::READY_FOR_REVIEW, Constants::REVIEW_REQUESTED]
      )
    end
  end
end
