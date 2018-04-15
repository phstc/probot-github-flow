module Webhooks
  class HandlePullRequest
    include Interactor
    include InteractorHelpers

    def_delegators :context, :payload, :access_token, :repo_full_name

    def call
      executor = case payload['action']
                 when 'closed'
                   HandlePullRequestActionClosed
                 when 'opened', 'edited', 'reopened'
                   HandlePullRequestActionOpened
                 when 'review_requested'
                   HandlePullRequestActionReviewRequested
                 end

      executor&.call!(payload: payload, repo_full_name: repo_full_name, access_token: access_token)
    end
  end
end
