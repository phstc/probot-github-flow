class CreateUser
  include Interactor
  include InteractorHelper

  def_delegators :context, :client_id, :client_secret, :session_code

  def call
    context.access_token = access_token

    user_hash = client.user

    user = User.where(login: user_hash[:login]).first_or_initialize
    user.email = user_hash[:email]
    user.company = user_hash[:company]
    user.name = user_hash[:name]
    user.access_token = access_token

    user.save

    context.user = user
  end

  private

  def access_token
    return context.access_token if context.access_token

    result = RestClient.post(
      'https://github.com/login/oauth/access_token',
      { client_id: client_id, client_secret: client_secret, code: session_code },
      accept: :json
    )

    context.access_token = JSON.parse(result)['access_token']
  end
end
