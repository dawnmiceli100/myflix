require 'spec_helper'

feature "the social networking functionality" do 
  scenario "the user follows and unfollows people" do
    dramas = Fabricate(:category, name: "Dramas") 
    video = Fabricate(:video, small_cover_art: 'video1small.jpg', category: dramas)
    bob = Fabricate(:user, email: "bobsmith@example.com", password: "bob", full_name: "Bob Smith")
    jane = Fabricate(:user, email: "janesmith@example.com", password: "jane", full_name: "Jane Smith") 
    review = Fabricate(:review, user: bob, video: video)
    
    sign_in(jane)

    link_to_video(video) 
    expect(page).to have_content video.title
  
    link_to_user(bob) 
    expect(page).to have_content bob.full_name
    expect(page).to have_content 'Follow'

    click_link 'Follow'
    expect(page).to have_content bob.full_name

    visit(people_path)
    link_to_unfollow
    expect(page).to have_content "no longer following #{bob.full_name}"
    
    visit(people_path)
    expect(page).not_to have_content bob.full_name
    
  end

  def link_to_user(user)
    find("a[href='/users/#{user.id}']").click
  end 

  def link_to_unfollow
    find("a[rel='nofollow']").click
  end 

end