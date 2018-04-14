module Webhooks
  class HandleIssues
    include Interactor
    include InteractorHelpers

    def_delegators :context, :payload

    def call
      case payload['action']
      when 'labeled'
        HandleIssuesActionLabeled.call!(payload: payload)
      when 'closed'
        HandleIssuesActionClosed.call!(payload: payload)
      end
    end
  end
end
