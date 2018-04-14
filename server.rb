require 'bundler/setup'
require 'sinatra'
require 'rest_client'
require 'json'
require 'octokit'
require 'interactor'
require './app/interactors/interactor_helpers'
require './app/interactors/remove_label'
require './app/interactors/add_label_to_an_issue'
require './app/interactors/setup_labels'
require './app/interactors/webhooks/handle_issues'
require './app/interactors/create_hooks'
require './app/interactors/create_user'
require './app/interactors/get_oauth_url'
require './github'

Bundler.require(:default, ENV['RACK_ENV'] || 'development')

CLIENT_ID = ENV['GH_BASIC_CLIENT_ID']
CLIENT_SECRET = ENV['GH_BASIC_SECRET_ID']
ACCESS_TOKEN = ENV['GH_ACCESS_TOKEN']

use Rack::Session::Cookie, key: 'PutsLabel',
                           path: '/',
                           expire_after: 14_400,
                           secret: ENV['COOKIE_SECRET']

def authenticated?
  session[:access_token]
end

def authenticate!
  oauth_url = GetOauthURL.call!(client_id: CLIENT_ID).oauth_url

  erb :login, locals: { oauth_url: oauth_url }
end

get '/' do
  return authenticate! unless authenticated?

  access_token = session[:access_token]

  CreateHooks.call!(access_token: access_token)

  client = Octokit::Client.new(access_token: access_token)

  erb :index, locals: { user: client.user.to_h, access_token: access_token }
end

post '/webhook' do
  github = GitHub.new(ACCESS_TOKEN)
  github.handle_github(request.env['HTTP_X_GITHUB_EVENT'], JSON.parse(request.body.read))
  status 200
end

get '/callback' do
  session_code = request.env['rack.request.query_hash']['code']

  session[:access_token] = CreateUser.call!(
    session_code: session_code,
    client_id: CLIENT_ID,
    client_secret: CLIENT_SECRET
  ).access_token

  redirect '/'
end
