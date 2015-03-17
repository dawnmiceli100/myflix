require 'spec_helper'

describe User do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:full_name) }
  it { should validate_uniqueness_of(:email) }
  it { should have_many(:queue_items).order(:queue_position) }
  it { should have_many(:reviews).order(created_at: :desc) }

  describe "#follows?" do
    let(:jane) { Fabricate(:user) }
    let(:bob) { Fabricate(:user) } 

    it "returns true if the user follows the other user" do
      Fabricate(:relationship, follower: bob, followed: jane)
      expect(bob.follows?(jane)).to be_truthy
    end  

    it "returns false if the user does not follow the other user" do
      expect(bob.follows?(jane)).to be_falsey
    end 
  end 

  describe "#initiate_password_reset" do
    let(:jane) { Fabricate(:user) }

    it "sets the reset_token column" do
      column = :reset_token
      jane.initiate_password_reset
      expect(User.first.reset_token).not_to be_blank
    end 

    it "sets the reset_sent_at column" do
      column = :reset_token
      jane.initiate_password_reset
      expect(User.first.reset_sent_at).not_to be_blank
    end  

    it "sends out the reset password email" do
      jane.initiate_password_reset
      expect(ActionMailer::Base.deliveries).not_to be_blank  
    end 

    it "sends the reset password email to the correct user" do
      jane.initiate_password_reset
      email = ActionMailer::Base.deliveries.last
      expect(email.to).to eq([jane.email])    
    end 

    it "sends the reset password email with the right content" do
      jane.initiate_password_reset
      email = ActionMailer::Base.deliveries.last
      expect(email.body).to include("Click")    
    end  
  end  
end