module Webhooks
  class HandlePullRequestReview
    include Interactor
    include InteractorHelpers

    def_delegators :context, :payload, :repo_full_name

    def call
      id = payload['issue']['number']

      case payload['review']['state']
      when 'changes_requested'
        reject_issue(id)
      when 'approved'
        remove_review_requested
      end
    end

    private

    def reject_issue
      Webhooks::FindFixableIssues.call!(payload['pull_request']['body']).each do |id|
        AddLabelToAnIssue.call!(repo_full_name: repo_full_name, id: id, label: Constants::REJECTED)
      end
    end

    def remove_review_requested
      Webhooks::FindFixableIssues.call!(payload['pull_request']['body']).each do |id|
        RemoveLabel.call!(repo_full_name: repo_full_name, id: id, label: Constants::REVIEW_REQUESTED)
      end
    end
  end
end
