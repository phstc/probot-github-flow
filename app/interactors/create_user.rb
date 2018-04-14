class CreateUser
  include InteractorHelpers

  attr_reader :context

  class << self
    def call!(context = {})
      new(context).call
    end
  end

  def initialize(context)
    @context = OpenStruct.new(context)
  end

  def call
    result = RestClient.post(
      'https://github.com/login/oauth/access_token',
      { client_id: context.client_id, client_secret: context.client_secret, code: context.session_code },
      accept: :json
    )

    context.access_token = JSON.parse(result)['access_token']

    context.user = client.user

    context
  end
end
