module Webhooks
  class HandlePullRequestReviewStateApproved
    include Interactor
    include InteractorHelpers

    def_delegators :context, :payload, :repo_full_name, :access_token

    def call
      each_fixable_issue(payload['pull_request']['body']) do |id|
        RemoveLabel.call!(
          repo_full_name: repo_full_name,
          id: id,
          label: [Constants::REVIEW_REQUESTED, Constants::REJECTED],
          access_token: access_token
        )
      end
    end
  end
end
