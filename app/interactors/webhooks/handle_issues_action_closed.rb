module Webhooks
  class HandleIssuesActionClosed
    include Interactor
    include InteractorHelpers

    def_delegators :context, :payload, :repo_full_name

    def call
      id = payload['issue']['number']

      RemoveLabel.call!(
        repo_full_name: repo_full_name,
        id: id,
        label: [Constants::IN_PROGRESS, Constants::READY_FOR_REVIEW, Constants::REVIEW_REQUESTED]
      )
    end
  end
end
