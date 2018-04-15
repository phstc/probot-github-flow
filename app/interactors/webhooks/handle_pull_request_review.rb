module Webhooks
  class HandlePullRequestReview
    include Interactor
    include InteractorHelper

    def_delegators :context, :payload, :repo_full_name, :access_token

    def call
      executor = case payload['review']['state']
                 when 'changes_requested'
                   HandlePullRequestReviewStateChangesRequested
                 when 'approved'
                   HandlePullRequestReviewStateApproved
                 end

      executor&.call!(
        payload: payload,
        repo_full_name: repo_full_name,
        access_token: access_token
      )
    end
  end
end
