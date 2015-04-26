require 'spec_helper'

feature "the add a video functionality" do 
  scenario "an admin user adds a video that other users can watch and/or add to their queue" do
    comedies = Fabricate(:category, name: "Comedies") 
    admin = Fabricate(:user, admin: true)
    non_admin = Fabricate(:user)

    sign_in(admin)
    add_a_video
    click_link 'Sign Out'
    
    sign_in(non_admin)
    visit(video_path(Video.first))
    expect(page).to have_content('30 Rock')
    expect(page).to have_selector("img[src='/uploads/30_rock_large.jpg']")
    expect(page).to have_selector("a[href='https://www.youtube.com/watch?v=xxx']")
  end

  def add_a_video
    visit(new_admin_video_path)
    fill_in "Title", with: "30 Rock"
    select("Comedies", from: "Category")
    fill_in "Description", with: "This is a great show!"
    attach_file "Large Cover", "spec/support/uploads/30_rock_large.jpg"
    attach_file "Small Cover", "spec/support/uploads/30_rock_small.jpg"
    fill_in "Video URL", with: "https://www.youtube.com/watch?v=xxx"
    click_button "Add Video"
  end   
end