class SessionsController < ApplicationController

  layout 'sessions'

  def new
  end

  def create
    if user = User.ebay_authenticate(params[:username], params[:password])
      session[:user_id] = user.id
      redirect_to root_url, notice: "Logged in!"
    else
      flash.now.alert = "Username or password is invalid"
      render "new"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "Logged out!"
  end

end
