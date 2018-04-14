require 'bundler/setup'
require 'sinatra'
require 'rest_client'
require 'json'
require 'octokit'
require './github'
require './app/interactors/create_hooks'
require './app/interactors/create_users'

Bundler.require(:default, ENV['RACK_ENV'] || 'development')

SCOPES = [
  'user:email',
  'repo',
  'write:repo_hook'
].freeze

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
  oauth_url = "https://github.com/login/oauth/authorize?scope=#{SCOPES.join(',')}&client_id=#{CLIENT_ID}"

  erb :index, locals: { oauth_url: oauth_url }
end

get '/' do
  return authenticate! unless authenticated?

  access_token = session[:access_token]

  CreateHooks.call!(access_token: access_token)

  erb :advanced, locals: { access_token: access_token }
end

post '/webhook' do
  github = GitHub.new(ACCESS_TOKEN)
  github.handle_github(request.env['HTTP_X_GITHUB_EVENT'], JSON.parse(request.body.read))
  status 200
end

get '/callback' do
  session_code = request.env['rack.request.query_hash']['code']

  session[:access_token] = CreateUser.call!(session_code: session_code, client_id: CLIENT_ID, client_secret: CLIENT_SECRET)

  redirect '/'
end
