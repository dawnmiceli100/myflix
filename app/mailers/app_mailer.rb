class AppMailer < ActionMailer::Base
  default from: ENV["gmail_username"]

  def welcome_new_user(user)
    @user = user
    mail to: user.email, subject: "Welcome to MyFlix"
  end

  def reset_password(user)
    @user = user
    mail to: user.email, subject: "Password reset instructions"
  end

  def invite_friend(invitation)
    @invitation = invitation
    mail to: invitation.invitee_email, subject: "Invitation to join MyFlix"
  end  
end