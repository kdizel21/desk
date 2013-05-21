class HomeController < ApplicationController
  before_filter :set_user

  def index

  end

  def show
    @user
    #format.json do
    #  render :json => @user, :status => 200
    #end
  end
end
