require 'spec_helper'

describe QueueItem do
  it { should belong_to(:user) }
  it { should belong_to(:video) }
  it { should validate_uniqueness_of(:video_id).scoped_to(:user_id) }
  it { should validate_numericality_of(:queue_position).only_integer }

  describe '#video_title' do
    it "returns the title of the video associated with the queue_item" do
      video = Fabricate(:video, title: "Mary Poppins")
      user = Fabricate(:user)
      queue_item = Fabricate(:queue_item, user: user, video: video)
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

  describe "rating=" do
    it "updates the rating for the review if it exists" do
      video = Fabricate(:video, title: "Mary Poppins")
      user = Fabricate(:user)
      review = Fabricate(:review, rating: 3, user: user, video: video)
      queue_item = Fabricate(:queue_item, video: video, user: user)
      queue_item.rating = 1
      expect(Review.first.rating).to eq(1)
    end
    
    it "creates a new review with the rating only (no body), if the review exists" do
      video = Fabricate(:video, title: "Mary Poppins")
      user = Fabricate(:user)
      queue_item = Fabricate(:queue_item, video: video, user: user)
      queue_item.rating = 1
      expect(Review.first.rating).to eq(1)
    end

    it "updates the rating to nil if the blank rating is selected" do
      video = Fabricate(:video, title: "Mary Poppins")
      user = Fabricate(:user)
      review = Fabricate(:review, rating: 3, user: user, video: video)
      queue_item = Fabricate(:queue_item, video: video, user: user)
      queue_item.rating = nil
      expect(Review.first.rating).to be_nil
    end 
  end  

  describe '#category_name' do
    it "returns the name of the category of the video associated with the queue_item" do
      category = Fabricate(:category, name: "Dramas")
      video = Fabricate(:video, category: category)
      user = Fabricate(:user)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      expect(queue_item.category_name).to eq("Dramas")
    end  
  end 

  describe '#category' do
    it "returns the category of the video associated with the queue_item" do
      dramas = Fabricate(:category, name: "Dramas")
      video = Fabricate(:video, category: dramas)
      user = Fabricate(:user)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      expect(queue_item.category).to eq(dramas)
    end  
  end       
end