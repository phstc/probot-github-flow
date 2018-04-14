module Webhooks
  class HandlePullRequestReview
    include Interactor
    include InteractorHelpers

    def_delegators :context, :payload, :repo_full_name

    def call
      Webhooks::FindFixableIssues.call!(payload['pull_request']['body']).each do |id|
        AddLabelToAnIssue.call!(repo_full_name: repo_full_name, id: id, label: Constants::REJECTED)
      end
    end
  end
end
