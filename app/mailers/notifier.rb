class Notifier < ActionMailer::Base

  def welcome(user)
    @user = user
    setup_email("hippo.notification@gmail.com", @user.email, "Hippo -  invitation.")
  end

  private


  def setup_email(sent_by, sent_to, subject)
    sent_by = sent_by == nil ? "Invitation@checkinforgood.com" : sent_by
    mail(:from => sent_by,
         :to => sent_to,
         :subject => subject)
  end

end
