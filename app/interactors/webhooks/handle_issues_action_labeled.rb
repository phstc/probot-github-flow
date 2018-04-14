module Webhooks
  class HandleIssuesActionLabeled
    include Interactor
    include InteractorHelpers

    def_delegators :context, :payload, :repo_full_name, :access_token

    def call
      id = payload['issue']['number']

      case payload.dig('label', 'name')
      when Constants::READY_FOR_REVIEW
        remove_label(id, Constants::IN_PROGRESS)
      when Constants::REJECTED
        remove_label(id, [Constants::IN_PROGRESS, Constants::READY_FOR_REVIEW])
      when Constants::REVIEW_REQUESTED
        remove_label(id, Constants::IN_PROGRESS)
        add_label_to_an_issue(id, Constants::READY_FOR_REVIEW)
      end
    end

    private

    def remove_label(id, label)
      RemoveLabel.call!(
        repo_full_name: repo_full_name,
        id: id,
        label: label,
        access_token: access_token
      )
    end

    def add_label_to_an_issue(id, label)
      AddLabelToAnIssue.call!(
        repo_full_name: repo_full_name,
        id: id,
        label: label,
        access_token: access_token
      )
    end
  end
end
