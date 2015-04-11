class AppMailer < ActionMailer::Base
  default from: ENV["gmail_username"]

  def welcome_new_user(user)
    @user = user
    if Rails.env.staging?
      email = ENV["staging_email"]
    else  
      email = user.email
    end  
    mail to: email, subject: "Welcome to MyFlix"
  end

  def reset_password(user)
    @user = user
    if Rails.env.staging?
      email = ENV["staging_email"]
    else  
      email = user.email
    end  
    mail to: email, subject: "Password reset instructions"
  end

  def invite_friend(invitation)
    @invitation = invitation
    if Rails.env.staging?
      email = ENV["staging_email"]
    else  
      email = invitation.invitee_email
    end  
    mail to: email, subject: "Invitation to join MyFlix"
  end 

end