class SessionsController < ApplicationController
  skip_before_filter :authorize!

  def create  # For Guest login Session
    @user = params[:user] ? User.find_or_initialize_by_email_and_name(params[:user][:email],params[:user][:name]) : User.new_guest
    if @user.save
      session[:user_id] = @user.id
      redirect_to cloud_providers_path, :notice => "Successfuly login as Guest. Dont worry, once you logout we flush all your data"
    else
      render "new"
    end
  end

  def destroy #for Guest Logout

    user = current_user
    session[:user_id] = nil
    thread = Thread.new do
    cloud_providers = user.cloud_providers
    cloud_providers.each{|c| c.destroy}
   end
   thread.run

    redirect_to root_url, notice: "Logged out!"
  end
end