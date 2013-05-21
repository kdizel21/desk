class ApplicationController < ActionController::Base
  #protect_from_forgery

  def set_user
    begin
      @user ||= User.find(session['user']) if session['user']
      @user_info = {}
      if @user
        @user_info = {
          :id => @user.id,
          :email => @user.email
        }.to_json
      else
        app_logout
        render :controller => 'users', :action => 'index'
      end
    rescue Exception => e
      app_logout
      render :controller => 'users', :action => 'index'
      return
    end
  end

  def app_logout
    reset_session
    session['logout'] = Time.now.utc
  end

  def user_authenticates?
    user = User.where(:email => params['user']['email']).first
    if user && user.authenticate(user, params['user']['password'])
      @user = user
      session['user'] = @user.id
    else
      return false
    end
  end

  protected

  def authenticate_user
    if session['user']
      @user = User.find(session['user'])
    else
      render :controller => 'users'
    end
  end
end
