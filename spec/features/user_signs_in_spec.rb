require 'spec_helper'

feature "the user sign in process" do 
  
  scenario "with valid input" do
    jane = Fabricate(:user)
    sign_in(jane)
    expect(page).to have_content 'successfully'
  end  

  scenario "with invalid input" do
    visit sign_in_path
    fill_in 'Email Address', with: 'janesmith@error.com'
    fill_in 'Password', with: 'error'
    click_button 'Sign in'
    expect(page).to have_content 'incorrect'
  end  

  scenario "with locked user" do
    jane = Fabricate(:user, locked: true)
    sign_in(jane)
    expect(page).to have_content("locked")
  end  
end