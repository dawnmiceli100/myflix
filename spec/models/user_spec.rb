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
end