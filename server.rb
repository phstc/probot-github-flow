require 'bundler/setup'
require 'sinatra'
require 'rest_client'
require 'json'
require 'octokit'
require 'interactor'
require 'mongoid'
require './constants'
require './app/interactors/interactor_helper'

Dir['./app/models/**/*.rb'].each(&method(:require))
Dir['./app/interactors/**/*.rb'].each(&method(:require))

Bundler.require(:default, ENV['RACK_ENV'] || 'development')

CLIENT_ID = ENV['GH_BASIC_CLIENT_ID']
CLIENT_SECRET = ENV['GH_BASIC_SECRET_ID']
ACCESS_TOKEN = ENV['GH_ACCESS_TOKEN']

use Rack::Session::Cookie, key: 'PutsLabel',
                           path: '/',
                           expire_after: 14_400,
                           secret: ENV['COOKIE_SECRET']

Mongoid.load!('./config/mongoid.yml', ENV['RACK_ENV'] || 'development')

def authenticated?
  session[:login]
end

def authenticate!
  oauth_url = GetOauthURL.call!(client_id: CLIENT_ID).oauth_url

  erb :login, locals: { oauth_url: oauth_url }
end

get '/' do
  return authenticate! unless authenticated?

  access_token = session[:access_token]

  CreateHooks.call!(access_token: access_token)

  user = User.where(login: session[:login]).first

  erb :index, locals: { user: user }
end

post '/webhook' do
  Webhooks::HandleWebhook.call!(
    access_token: ACCESS_TOKEN,
    type: request.env['HTTP_X_GITHUB_EVENT'],
    payload: JSON.parse(request.body.read)
  )
  status 200
end

post '/repositories' do
  user = User.where(login: session[:login]).first

  CreateRepository.call!(user: user, full_name: params['full_name'])

  redirect '/'
end

get '/callback' do
  session_code = request.env['rack.request.query_hash']['code']

  user = CreateUser.call!(
    session_code: session_code,
    client_id: CLIENT_ID,
    client_secret: CLIENT_SECRET
  ).user

  session[:login] = user.login

  redirect '/'
end
