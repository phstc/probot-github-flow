class RepositoriesController < ApplicationController
  before_action :authenticate_user!

  def create
    user = User.where(login: session[:login]).first

    CreateRepository.call!(user: user, full_name: params['full_name'])

    redirect_to root_path
  end
end
