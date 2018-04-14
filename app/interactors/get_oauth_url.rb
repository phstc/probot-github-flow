class GetOauthURL
  include Interactor

  SCOPES = [
    'user:email',
    'repo',
    'write:repo_hook'
  ].freeze

  def call
    context.oauth_url = "https://github.com/login/oauth/authorize?scope=#{SCOPES.join(',')}&client_id=#{context.client_id}"
  end
end
