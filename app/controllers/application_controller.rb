class ApplicationController < ActionController::Base
  def authenticated?
    session[:login]
  end

  def authenticate_user!
    redirect_to login_path unless authenticated?
  end
end
