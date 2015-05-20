require 'spec_helper'  

describe VideoDecorator do

  it "returns 'Average Rating: N/A' if there are not any reviews" do
    waiting_for_superman = Video.create(title: "Waiting for Superman", description: "The state of American education.").decorate
    superman = Video.create(title: "Superman", description: "Christopher Reeve.").decorate
    expect(superman.average_rating).to eq("Average Rating: N/A")
  end

  it "returns the rating of the video if 1 review exists" do
    waiting_for_superman = Video.create(title: "Waiting for Superman", description: "The state of American education.").decorate
    superman = Video.create(title: "Superman", description: "Christopher Reeve.").decorate
    user1 = Fabricate(:user)
    review1 = Fabricate(:review, video: superman, user: user1)
    expect(superman.average_rating).to eq("Average Rating: #{review1.rating.round(1)} Stars")
    
  end
  
  it "returns the average rating of the video if more than 1 review exists" do
    waiting_for_superman = Video.create(title: "Waiting for Superman", description: "The state of American education.").decorate
    superman = Video.create(title: "Superman", description: "Christopher Reeve.").decorate
    user1 = Fabricate(:user)
    user2 = Fabricate(:user)
    review1 = Fabricate(:review, video: superman, user: user1)
    review2 = Fabricate(:review, video: superman, user: user2)
    expect(superman.average_rating).to eq("Average Rating: #{superman.reviews.average(:rating).round(1)} Stars")
  end
 end   