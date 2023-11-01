class SessionsController < ApplicationController
  def new

  end

  def create
    
    user = User.where(['email = ? or username = ?', params[:email_or_username], params[:email_or_username]]).first

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to (session[:intended_url] || user), notice: "Welcome back #{user.name}"
      session[:intended_url] = nil
    else
      flash.now[:alert] = 'Incorrect email/password'
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: 'You have signed out successfully'
  end
end
