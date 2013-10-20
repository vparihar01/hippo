class Notifier < ActionMailer::Base

  def welcome(user)
    @user = user
    setup_email(@user.email, "Hippo -  Welcome Email.")
  end

  private


  def setup_email(sent_to, subject)
    mail(:from => 'hippo.notification@gmail.com',
         :to => sent_to,
         :subject => subject)
  end

end
