require 'spec_helper'

feature "the invite a friend functionality" do 
  scenario "the user invites a friend, the friend registers, the user and friend follow each other", js: true do
    inviter = Fabricate(:user)
    sign_in(inviter) 

    invite_friend_by_email

    click_link 'Sign Out'

    friend_clicks_link_in_email_invitation
    friend_registers
    friend_signs_in
    friend_is_following_inviter(inviter)
    
    click_link 'Sign Out'

    sign_in(inviter)
    inviter_is_following_friend
    
    clear_email  
  end

  def invite_friend_by_email
    click_link 'Invite a friend'
    fill_in "Friend's Name", with: "Bob"
    fill_in "Friend's Email Address", with: "bobmiller@example.com"
    fill_in "Invitation Message", with: "I think you'll really like this site!"
    click_button 'Send Invitation'
  end 

  def friend_clicks_link_in_email_invitation
    open_email('bobmiller@example.com')
    current_email.click_link('Join MyFlix')
  end 

  def friend_registers
    fill_in 'Password', with: "bob"
    fill_in 'Full Name', with: "Bob Miller"
    fill_in "Credit Card", with: '4242424242424242'
    fill_in "CVC",      with: "123"
    select "1 - January", from: "date_month"
    select "2019", from: "date_year"
    click_button 'Sign Up'
  end 

  def friend_signs_in
    fill_in 'Email Address', with: "bobmiller@example.com"
    fill_in 'Password', with: 'bob'
    click_button 'Sign in' 
  end 

  def friend_is_following_inviter(inviter)
    click_link 'People'
    expect(page).to have_content inviter.full_name
  end

  def inviter_is_following_friend
    click_link 'People'
    expect(page).to have_content 'Bob Miller'
  end  
end