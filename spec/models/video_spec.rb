require 'spec_helper'

describe Video do
  it { should belong_to(:category) }
  it { should have_many(:reviews).order("created_at DESC") }
  it { should have_many(:queue_items) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) } 

  describe "search_by_title" do
    it "returns an empty array if no matches are found" do
      waiting_for_superman = Video.create(title: "Waiting for Superman", description: "The state of American education.")
      superman = Video.create(title: "Superman", description: "Christopher Reeve.")
      expect(Video.search_by_title("Good")).to eq([])
    end

    it "returns an array of one video for an exact match" do
      waiting_for_superman = Video.create(title: "Waiting for Superman", description: "The state of American education.")
      superman = Video.create(title: "Superman", description: "Christopher Reeve.")
      expect(Video.search_by_title("Waiting for Superman")).to eq([waiting_for_superman])
    end
    
    it "returns an array of one video for a partial match" do
      waiting_for_superman = Video.create(title: "Waiting for Superman", description: "The state of American education.")
      superman = Video.create(title: "Superman", description: "Christopher Reeve.")
      expect(Video.search_by_title("Wait")).to eq([waiting_for_superman])
    end

    it "returns an array of all matches ordered by created_at desc" do
      waiting_for_superman = Video.create(title: "Waiting for Superman", description: "The state of American education.")
      superman = Video.create(title: "Superman", description: "Christopher Reeve.")
      expect(Video.search_by_title("Super")).to eq([superman, waiting_for_superman ])
    end

    it "returns an empty array if the search_string is blank" do
      waiting_for_superman = Video.create(title: "Waiting for Superman", description: "The state of American education.")
      superman = Video.create(title: "Superman", description: "Christopher Reeve.")
      expect(Video.search_by_title("")).to eq([])
    end
  end  

  describe "#in_users_queue?" do
    it "returns true if the video is in the user's queue" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      queue_item = Fabricate(:queue_item, video_id: video.id, user_id: user.id)
      expect(video.in_users_queue?(user)).to be true
    end
    
    it "returns false if the video is not in the user's queue" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      expect(video.in_users_queue?(user)).to be false
    end  
  end        
end