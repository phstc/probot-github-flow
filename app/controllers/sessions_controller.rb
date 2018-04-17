class SessionsController < ApplicationController
  CLIENT_ID = ENV['GH_BASIC_CLIENT_ID']
  CLIENT_SECRET = ENV['GH_BASIC_SECRET_ID']

  def index
    @oauth_url = GetOauthURL.call!(client_id: CLIENT_ID).oauth_url
  end

  def callback
    session_code = request.env['rack.request.query_hash']['code']

    user = CreateUser.call!(
      session_code: session_code,
      client_id: CLIENT_ID,
      client_secret: CLIENT_SECRET
    ).user

    session[:login] = user.login

    redirect_to '/'
  end
end
