module Webhooks
  class HandleIssues
    include Interactor
    include InteractorHelpers

    def_delegators :context, :payload, :repo_full_name

    def call
      case payload['action']
      when 'labeled'
        HandleIssuesActionLabeled.call!(payload: payload, repo_full_name: repo_full_name)
      when 'closed'
        HandleIssuesActionClosed.call!(payload: payload, repo_full_name: repo_full_name)
      end
    end
  end
end
