class GetOauthURL
  SCOPES = [
    'user:email',
    'repo',
    'write:repo_hook'
  ].freeze

  attr_reader :context

  class << self
    def call!(context)
      new(context).call
    end
  end

  def initialize(context)
    @context = OpenStruct.new(context)
  end

  def call
    context.oauth_url = "https://github.com/login/oauth/authorize?scope=#{SCOPES.join(',')}&client_id=#{context.client_id}"

    context
  end
end
