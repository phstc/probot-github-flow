module InteractorHelpers
  def self.included(base)
    base.extend Forwardable
  end

  private

  def each_fixable_issue(body, &block)
    Webhooks::FindFixableIssues.call!(body: body).ids.each(&block)
  end

  def client
    @_client = Octokit::Client.new(access_token: context.access_token)
  end
end
