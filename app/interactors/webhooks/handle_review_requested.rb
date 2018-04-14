module Webhooks
  class HandleReviewRequested
    include Interactor
    include InteractorHelpers

    def_delegators :context, :payload, :repo_full_name

    def call
      id = payload['issue']['number']

      case payload['review']['state']
      when 'changes_requested'
        reject_issue(id)
      when 'approved'
        remove_review_requested_issue(id)
      end
    end

    private

    def reject_issue(_id)
      Webhooks::FindFixableIssues.call!(payload['pull_request']['body']).each do |id|
        AddLabelToAnIssue.call!(repo_full_name: repo_full_name, id: id, label: REJECTED)
      end
    end

    def remove_review_requested_issue(_id)
      Webhooks::FindFixableIssues.call!(payload['pull_request']['body']).each do |id|
        RemoveLabel.call!(repo_full_name: repo_full_name, id: id, label: REVIEW_REQUESTED)
      end
    end
  end
end
