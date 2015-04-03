require 'spec_helper'

feature "the reset password functionality" do 
  scenario "the user resets their password and signs in with new password" do
    jane = Fabricate(:user, email: "janesmith@example.com", password: "jane", full_name: "Jane Smith") 
    
    visit(sign_in_path)
    click_link 'Forgot Password?'
    fill_in 'Email Address', with: jane.email
    click_button 'Send Email'

    open_email(jane.email)
    current_email.click_link('Reset Password')

    fill_in 'user_password', with: "new"
    click_button 'Reset Password'
    expect(page).to have_content 'Your password has been reset!'
  
    fill_in 'Email Address', with: jane.email
    fill_in 'Password', with: 'new'
    click_button 'Sign in' 
    expect(page).to have_content 'You have successfully signed in.' 

    clear_email  
  end
end