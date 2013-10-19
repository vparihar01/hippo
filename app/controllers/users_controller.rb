class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = params[:user] ? User.find_or_initialize_by_email(params[:user][:email]) : User.new_guest
    if @user.save
      current_user.move_to(@user) if current_user && current_user.guest?
      session[:user_id] = @user.id
      redirect_to root_url
    else
      render "new"
    end
  end
end
