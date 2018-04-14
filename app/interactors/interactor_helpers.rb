module InteractorHelpers
  extend Forwardable

  private

  def client
    @_client = Octokit::Client.new(access_token: context.access_token)
  end
end
