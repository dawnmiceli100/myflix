require 'spec_helper'

describe Category do
  it { should have_many(:videos) }
  it { should validate_presence_of(:name) }

  describe "#recent_videos" do

    it "returns an empty array if there are no videos for the category" do
      dramas = Category.create(name: "dramas")
      expect(dramas.recent_videos).to eq([])  
    end  

    it "returns all videos if there are less than 6 videos for the category ordered by created_at desc" do
      dramas = Category.create(name: "dramas")
      video1 = Video.create(title: "Video1", description: "This is video1.", category: dramas)
      video2 = Video.create(title: "Video2", description: "This is video2.", category: dramas)
      video3 = Video.create(title: "Video3", description: "This is video3.", category: dramas)
      video4 = Video.create(title: "Video4", description: "This is video4.", category: dramas)
      expect(dramas.recent_videos).to eq([video4, video3, video2, video1])
    end

    it "returns 6 videos if there are exactly 6 videos for the category ordered by created_at desc" do
      dramas = Category.create(name: "dramas")
      video1 = Video.create(title: "Video1", description: "This is video1.", category: dramas)
      video2 = Video.create(title: "Video2", description: "This is video2.", category: dramas)
      video3 = Video.create(title: "Video3", description: "This is video3.", category: dramas)
      video4 = Video.create(title: "Video4", description: "This is video4.", category: dramas)
      video5 = Video.create(title: "Video5", description: "This is video5.", category: dramas)
      video6 = Video.create(title: "Video6", description: "This is video6.", category: dramas)
      expect(dramas.recent_videos).to eq([video6, video5, video4, video3, video2, video1])
    end  

    it "returns 6 videos if there are more than 6 videos for the category ordered by created_at desc" do
      dramas = Category.create(name: "dramas")
      video1 = Video.create(title: "Video1", description: "This is video1.", category: dramas)
      video2 = Video.create(title: "Video2", description: "This is video2.", category: dramas)
      video3 = Video.create(title: "Video3", description: "This is video3.", category: dramas)
      video4 = Video.create(title: "Video4", description: "This is video4.", category: dramas)
      video5 = Video.create(title: "Video5", description: "This is video5.", category: dramas)
      video6 = Video.create(title: "Video6", description: "This is video6.", category: dramas)
      video7 = Video.create(title: "Video7", description: "This is video7.", category: dramas)
      expect(dramas.recent_videos).to eq([video7, video6, video5, video4, video3, video2])
    end  
  end  
end  