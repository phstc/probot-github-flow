module InteractorHelpers
  def self.included(base)
    base.extend Forwardable
  end

  private

  def client
    @_client = Octokit::Client.new(access_token: context.access_token)
  end
end
