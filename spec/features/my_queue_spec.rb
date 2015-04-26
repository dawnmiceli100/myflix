require 'spec_helper'

feature "the my queue functionality" do 
  scenario "the user adds videos to their queue and reorders them" do
    dramas = Fabricate(:category, name: "Dramas") 
    video1 = Fabricate(:video, small_cover_art: 'video1small.jpg', category: dramas)
    video2 = Fabricate(:video, small_cover_art: 'video2small.jpg', category: dramas) 
    video3 = Fabricate(:video, small_cover_art: 'video3small.jpg', category: dramas) 
    jane = User.create(email: 'janesmith@example.com', password: 'jane', full_name: 'jane smith') 

    sign_in(jane)

    link_to_video(video1) 
    expect(page).to have_content video1.title
   
    click_link '+ My Queue'
    expect(page).to have_content 'has been added'

    link_to_video(video1) 
    expect(page).to have_content video1.title
    expect(page).to_not have_content '+ My Queue'

    visit(home_path)
    link_to_video(video2)
    click_link '+ My Queue'

    visit(home_path)
    link_to_video(video3)
    click_link '+ My Queue'

    change_queue_position(video1, 3)
    change_queue_position(video2, 1)
    change_queue_position(video3, 2)
    click_button "Update Instant Queue"

    expect_queue_position(video1, 3)
    expect_queue_position(video2, 1)
    expect_queue_position(video3, 2)
    
  end

  def change_queue_position(video, position)
    find("input[data-video-id='#{video.id}']").set(position) 
  end 

  def expect_queue_position(video, position)
    expect(find("input[data-video-id='#{video.id}']").value).to eq(position.to_s)  
  end  

end