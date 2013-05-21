class UsersController < ApplicationController
  before_filter :set_user, :only => :index

  def index
    if @user
      redirect_to :controller => 'home', :action => 'index'
    end
    @user_info = {}
  end

  def new
    @user
  end

  def create
    if User.email_available?(params[:user][:email]) && request.method == "POST"
      user = User.new
      user.email = params[:user][:email]
      user.password_raw = params[:user][:password_raw]
      user.password_raw_confirmation = params[:user][:password_raw_confirmation]
      if user.save
        session['user'] = user.id
        respond_to do |format|
          format.json do
            render :json => {:user => user}, :status => :ok
          end
        end
      else
        render :json => {:error => "Please check that you entered a valid email and your password confirmation matches"},
               :status => :bad_request
      end
    else
      respond_to do |format|
        format.json do
          render :json => {:email => "email already in use"}, :status => :bad_request
        end
      end
    end
  end

  def logout
    app_logout
    redirect_to :controller => 'users', :action => 'index'
  end

  def login
    if user_authenticates? && request.method == "POST"
      userdata = { :id => @user.id, :email => @user.email }
      respond_to do |format|
        format.json do
          render :json => {:user => userdata}, :status => :ok
        end
      end
    else
      respond_to do |format|
        format.json do
          render :json => {"error" => "Incorrect email or password"}, :status => :bad_request
        end
      end
    end
  end
end
