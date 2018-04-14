module Webhooks
  class HandlePullRequestReview
    include Interactor
    include InteractorHelpers

    def_delegators :context, :payload, :repo_full_name

    def call
      case payload['review']['state']
      when 'changes_requested'
        HandlePullRequestReviewStateChangesRequested.call!(payload: payload, repo_full_name: repo_full_name)
      when 'approved'
        HandlePullRequestReviewStateApproved.call!(payload: payload, repo_full_name: repo_full_name)
      end
    end
  end
end
