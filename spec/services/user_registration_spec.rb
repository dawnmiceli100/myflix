require 'spec_helper'

describe UserRegistration do

  describe "#register" do
    context "with valid credit card" do
      let(:stripeToken) { 'abc123' }
      let(:amount) { 999 } 
      let(:charge) { double(:charge, successful?: true) }
      before do
        expect(StripeWrapper::Charge).to receive(:create).and_return(charge)
      end
        
      after { ActionMailer::Base.deliveries.clear }
     
      it "creates a User record" do
        UserRegistration.new(Fabricate.build(:user, email: "jane@example.com", password: "jane", full_name: "Jane Doe"), stripeToken, amount, nil).register
        expect(User.last.full_name).to eq("Jane Doe") 
      end

      it "sends out the welcome email" do
        UserRegistration.new(Fabricate.build(:user), stripeToken, amount, nil).register
        expect(ActionMailer::Base.deliveries).not_to be_blank  
      end 

      it "sends the welcome email to the correct user" do
        UserRegistration.new(Fabricate.build(:user, email: "jane@example.com", password: "jane", full_name: "Jane Doe"), stripeToken, amount, nil).register
        email = ActionMailer::Base.deliveries.last
        expect(email.to).to eq(["jane@example.com"])    
      end 

      it "sends the welcome email with the right content" do
        UserRegistration.new(Fabricate.build(:user, email: "jane@example.com", password: "jane", full_name: "Jane Doe"), stripeToken, amount, nil).register
        email = ActionMailer::Base.deliveries.last
        expect(email.body).to include("Jane Doe")    
      end 

      context "with invitation" do
        let(:bob) { Fabricate(:user) }
        let(:invitation) { Fabricate(:invitation, inviter: bob, invitee_name: "Jane", invitee_email: "jane@example.com") }
        
        before do
          UserRegistration.new(Fabricate.build(:user, email: "jane@example.com", password: "jane", full_name: "Jane Doe"), stripeToken, amount, invitation.token).register
        end  

        after { ActionMailer::Base.deliveries.clear }

        let(:jane) { User.find_by(email: "jane@example.com") }

        it "adds the relationship where the user follows the inviter" do 
          expect(jane.follows?(bob)).to be_truthy
        end 

        it "adds the relationship where the inviter follows the user" do 
          expect(bob.follows?(jane)).to be_truthy
        end 

        it "expires the invitation" do
          expect(Invitation.first.token).to be_nil
        end  
      end  
    end  

    context "with invalid credit card" do
      let(:stripeToken) { 'abc123' }
      let(:amount) { 999 }
      let(:charge) { double(:charge, successful?: false, error_message: 'Your card was declined.') }
      
      before do
        expect(StripeWrapper::Charge).to receive(:create).and_return(charge)
      end

      it "does not create a User record" do
        UserRegistration.new(Fabricate.build(:user, email: "jane@example.com", password: "jane", full_name: "Jane Doe"), stripeToken, amount, nil).register
        expect(User.count).to eq(0) 
      end  

      it "does not send out the welcome email" do
        expect {
          UserRegistration.new(Fabricate.build(:user, email: "jane@example.com", password: "jane", full_name: "Jane Doe"), stripeToken, amount, nil).register
        }.not_to change { ActionMailer::Base.deliveries.count }    
      end 
    end
  end  

  describe "#successful?" do
    it "returns true if register.status == :success" do
      stripeToken ='abc123' 
      invitation_token = 'xxx'
      amount = 999 
      charge = double(:charge, successful?: true) 

      expect(StripeWrapper::Charge).to receive(:create).and_return(charge)
      registration = UserRegistration.new(Fabricate.build(:user, email: "jane@example.com", password: "jane", full_name: "Jane Doe"), stripeToken, amount, nil).register
      expect(registration).to be_successful
    end 
    
    it "returns false if register.status != :success" do
      stripeToken ='abc123' 
      amount = 999 
      charge = double(:charge, successful?: false, error_message: 'Your card was declined.')
      expect(StripeWrapper::Charge).to receive(:create).and_return(charge)
      registration = UserRegistration.new(Fabricate.build(:user, email: "jane@example.com", password: "jane", full_name: "Jane Doe"), stripeToken, amount, nil).register
      expect(registration).not_to be_successful
    end 

  end
end