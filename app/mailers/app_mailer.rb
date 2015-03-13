class AppMailer < ActionMailer::Base
  default from: ENV["gmail_username"]
  def welcome_new_user(user)
    mail to: user.email, subject: "Welcome to MyFlix"
  end
end