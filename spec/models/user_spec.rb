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

  describe "#can_follow?" do
    let(:jane) { Fabricate(:user) }
    let(:bob) { Fabricate(:user) } 

    it "returns true if the user does not follow another user" do
      expect(bob.can_follow?(jane)).to be_truthy
    end
    
    it "returns false if the user already follows another user" do
      Fabricate(:relationship, follower: bob, followed: jane)
      expect(bob.can_follow?(jane)).to be_falsey
    end  

    it "returns false if the user tries to follow themself" do
      expect(bob.can_follow?(bob)).to be_falsey
    end  
  end  

  describe "#will_follow" do
    let(:jane) { Fabricate(:user) }
    let(:bob) { Fabricate(:user) } 

    it "sets the user to follow another user" do
      expect(bob.will_follow(jane)).to be_truthy
    end
    
    it "does not set the user to follow itself" do
      expect(bob.will_follow(bob)).to be_falsey
    end  
  end  

  describe "#initiate_password_reset" do
    let(:jane) { Fabricate(:user) }

    after { ActionMailer::Base.deliveries.clear }

    it "sets the reset_token column" do
      column = :reset_token
      jane.initiate_password_reset
      expect(User.first.reset_token).not_to be_blank
    end 

    it "sets the reset_sent_at column" do
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
      expect(email.body).to include(jane.reset_token)    
    end 

  end  
end