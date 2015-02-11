require 'spec_helper'

describe QueueItem do
  it { should belong_to(:user) }
  it { should belong_to(:video) }

  describe '#video_title' do
    it "returns the title of the video associated with the queue_item" do
      video = Fabricate(:video, title: "Mary Poppins")
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.video_title).to eq("Mary Poppins")
    end  
  end 

  describe '#rating' do
    it "returns the rating of the review associated with the queue_item user and video, if there is a review" do
      video = Fabricate(:video, title: "Mary Poppins")
      user = Fabricate(:user)
      review = Fabricate(:review, rating: 3, user: user, video: video)
      queue_item = Fabricate(:queue_item, video: video, user: user)
      expect(queue_item.rating).to eq(3)
    end  

    it "returns nil if there is no review associated with the queue_item user and video" do
      video = Fabricate(:video, title: "Mary Poppins")
      user = Fabricate(:user)
      queue_item = Fabricate(:queue_item, video: video, user: user)
      expect(queue_item.rating).to eq(nil)
    end  
  end 

  describe '#category_name' do
    it "returns the name of the category of the video associated with the queue_item" do
      category = Fabricate(:category, name: "Dramas")
      video = Fabricate(:video, category: category)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.category_name).to eq("Dramas")
    end  
  end 

  describe '#category' do
    it "returns the category of the video associated with the queue_item" do
      dramas = Fabricate(:category, name: "Dramas")
      video = Fabricate(:video, category: dramas)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.category).to eq(dramas)
    end  
  end       
end