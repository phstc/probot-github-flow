module Webhooks
  class HandleIssuesActionClosed
    include Interactor
    include InteractorHelpers

    def_delegators :context, :payload, :repo_full_name, :access_token

    def call
      id = payload['issue']['number']

      RemoveLabel.call!(
        repo_full_name: repo_full_name,
        id: id,
        label: [Constants::IN_PROGRESS, Constants::READY_FOR_REVIEW, Constants::REVIEW_REQUESTED],
        access_token: access_token
      )
    end
  end
end
