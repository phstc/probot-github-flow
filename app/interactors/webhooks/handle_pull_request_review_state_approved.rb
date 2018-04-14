module Webhooks
  class HandlePullRequestReview
    include Interactor
    include InteractorHelpers

    def_delegators :context, :payload, :repo_full_name

    def call
      Webhooks::FindFixableIssues.call!(payload['pull_request']['body']).each do |id|
        RemoveLabel.call!(repo_full_name: repo_full_name, id: id, label: Constants::REVIEW_REQUESTED)
      end
    end
  end
end
