class RepositoriesController < ApplicationController
  before_action :authenticate_user!

  def create
    user = User.where(login: session[:login]).first

    CreateRepository.call!(user: user, full_name: respository_params['full_name'])

    redirect_to root_path
  end

  private

  def respository_params
    params.require(:repository).permit(:full_name)
  end
end
