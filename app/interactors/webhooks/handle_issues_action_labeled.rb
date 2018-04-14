module Webhooks
  class HandleIssuesActionLabeled
    include Interactor
    include InteractorHelpers

    def_delegators :context, :payload, :repo_full_name

    def call
      id = payload['issue']['number']

      case payload.dig('label', 'name')
      when Constants::READY_FOR_REVIEW
        RemoveLabel.call!(
          repo_full_name: repo_full_name,
          id: id,
          label: Constants::IN_PROGRESS
        )
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
  end
end
