class SessionsController < ApplicationController
  skip_before_filter :authorize!

  def create  # For Guest login Session
    @user = params[:user] ? User.find_or_initialize_by_email_and_name(params[:user][:email],params[:user][:name]) : User.new_guest
    if @user.save
      Notifier.welcome(@user).deliver
      session[:user_id] = @user.id
      redirect_to root_url, :notice => "Successfuly login as Guest"
    else
      render "new"
    end
  end

  def destroy #for Guest Logout
    session[:user_id] = nil
    redirect_to root_url, notice: "Logged out!"
  end
end