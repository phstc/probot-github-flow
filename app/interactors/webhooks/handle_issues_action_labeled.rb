module Webhooks
  class HandleIssuesActionLabeled
    include Interactor
    include InteractorHelpers

    def_delegators :context, :payload, :repo_full_name, :access_token

    def call
      id = payload['issue']['number']

      case payload.dig('label', 'name')
      when Constants::READY_FOR_REVIEW
        RemoveLabel.call!(
          repo_full_name: repo_full_name,
          id: id,
          label: Constants::IN_PROGRESS,
          access_token: access_token
        )
      when Constants::REJECTED
        RemoveLabel.call!(
          repo_full_name: repo_full_name,
          id: id,
          label: [Constants::IN_PROGRESS, Constants::READY_FOR_REVIEW],
          access_token: access_token
        )
      when Constants::REVIEW_REQUESTED
        RemoveLabel.call!(
          repo_full_name: repo_full_name,
          id: id,
          label: Constants::IN_PROGRESS,
          access_token: access_token
        )
        AddLabelToAnIssue.call!(
          repo_full_name: repo_full_name,
          id: id,
          label: Constants::READY_FOR_REVIEW,
          access_token: access_token
        )
      end
    end
  end
end
