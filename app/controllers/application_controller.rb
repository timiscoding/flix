class ApplicationController < ActionController::Base
  helper_method :current_user, :current_user?, :current_user_admin?

  private

  def require_signin
    unless current_user
      session[:intended_url] = request.url
      redirect_to new_session_path, notice: 'Please sign in first'
    end
  end

  def require_admin
    redirect_to root_path, alert: 'Unauthorised access!' unless current_user_admin?
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def current_user?(user)
    current_user == user
  end

  def current_user_admin?
    current_user && current_user.admin?
  end

end
