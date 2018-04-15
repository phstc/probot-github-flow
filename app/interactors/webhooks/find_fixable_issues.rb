module Webhooks
  class FindFixableIssues
    include Interactor
    include InteractorHelper

    def_delegators :context, :body

    def call
      matches = body.scan(/(close|closes|closed|fix|fixes|fixed|resolve|resolves|resolved)\s*(\#\d+|http.*\/\d+)/i)

      context.numbers = matches.map!(&:last).map! do |issue|
        if issue.start_with?('#') # #7631"
          issue.sub('#', '')
        else
          issue.split('/').last # https://github.com/woodmont/spreeworks/issues/7631
        end
      end.uniq
    end
  end
end
