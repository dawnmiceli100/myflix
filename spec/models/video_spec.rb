require 'spec_helper'

describe Video do
  it { should belong_to(:category) }
  it { should have_many(:reviews).order("created_at DESC") }
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

  describe "#average_rating" do
    it "returns 0 if there are not any reviews" do
      waiting_for_superman = Video.create(title: "Waiting for Superman", description: "The state of American education.")
      superman = Video.create(title: "Superman", description: "Christopher Reeve.")
      expect(superman.average_rating).to eq(0)
    end

    it "returns the rating of the video if 1 review exists" do
      waiting_for_superman = Video.create(title: "Waiting for Superman", description: "The state of American education.")
      superman = Video.create(title: "Superman", description: "Christopher Reeve.")
      user1 = Fabricate(:user)
      review1 = Fabricate(:review, video: superman, user: user1)
      expect(superman.average_rating).to eq(review1.rating)
    end
    
    it "returns the average rating of the video if more than 1 review exists" do
      waiting_for_superman = Video.create(title: "Waiting for Superman", description: "The state of American education.")
      superman = Video.create(title: "Superman", description: "Christopher Reeve.")
      user1 = Fabricate(:user)
      user2 = Fabricate(:user)
      review1 = Fabricate(:review, video: superman, user: user1)
      review2 = Fabricate(:review, video: superman, user: user2)
      expect(superman.average_rating).to eq(((review1.rating + review2.rating) / 2).round(1))
    end
  end          
end