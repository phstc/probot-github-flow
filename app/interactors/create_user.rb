class CreateUser
  include Interactor
  include InteractorHelpers

  def call
    result = RestClient.post(
      'https://github.com/login/oauth/access_token',
      { client_id: context.client_id, client_secret: context.client_secret, code: context.session_code },
      accept: :json
    )

    context.access_token = JSON.parse(result)['access_token']

    context.user = client.user
  end
end
