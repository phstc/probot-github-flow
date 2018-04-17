class HomeController < ApplicationController
  before_action :authenticate_user!
  def index
    @user = User.where(login: session[:login]).first

    CreateHooks.call!(access_token: @user.access_token)
  end
end
