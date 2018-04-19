class HomeController < ApplicationController
  before_action :authenticate_user!
  def index
    @user = User.where(login: session[:login]).first

    @repository = Repository.new

    CreateHooks.call!(access_token: @user.access_token)
  end
end
