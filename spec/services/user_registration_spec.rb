require 'spec_helper'

describe UserRegistration do

  describe "#register" do
    context "with valid credit card" do
      let(:stripeToken) { 'abc123' }
      let(:customer) { double(:customer, successful?: true, id: 'CUST_1') }

      before do
        expect(StripeWrapper::Customer).to receive(:create).and_return(customer)
      end
        
      after { ActionMailer::Base.deliveries.clear }
     
      it "creates a User record" do
        UserRegistration.new(Fabricate.build(:user, email: "jane@example.com", password: "jane", full_name: "Jane Doe", stripe_customer_id: customer.id), stripeToken, nil).register
        expect(User.last.full_name).to eq("Jane Doe") 
      end

      it "sends out the welcome email" do
        UserRegistration.new(Fabricate.build(:user), stripeToken, nil).register
        expect(ActionMailer::Base.deliveries).not_to be_blank  
      end 

      it "sends the welcome email to the correct user" do
        UserRegistration.new(Fabricate.build(:user, email: "jane@example.com", password: "jane", full_name: "Jane Doe", stripe_customer_id: customer.id), stripeToken, nil).register
        email = ActionMailer::Base.deliveries.last
        expect(email.to).to eq(["jane@example.com"])    
      end 

      it "sends the welcome email with the right content" do
        UserRegistration.new(Fabricate.build(:user, email: "jane@example.com", password: "jane", full_name: "Jane Doe", stripe_customer_id: customer.id), stripeToken, nil).register
        email = ActionMailer::Base.deliveries.last
        expect(email.body).to include("Jane Doe")    
      end 

      context "with invitation" do
        let(:bob) { Fabricate(:user) }
        let(:invitation) { Fabricate(:invitation, inviter: bob, invitee_name: "Jane", invitee_email: "jane@example.com") }
        
        before do
          UserRegistration.new(Fabricate.build(:user, email: "jane@example.com", password: "jane", full_name: "Jane Doe", stripe_customer_id: customer.id), stripeToken, invitation.token).register
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
      let(:customer) { double(:customer, successful?: false, id: nil, error_message: 'Your card was declined.') }
      
      before do
        expect(StripeWrapper::Customer).to receive(:create).and_return(customer)
      end

      it "does not create a User record" do
        UserRegistration.new(Fabricate.build(:user, email: "jane@example.com", password: "jane", full_name: "Jane Doe", stripe_customer_id: customer.id), stripeToken, nil).register
        expect(User.count).to eq(0) 
      end  

      it "does not send out the welcome email" do
        expect {
          UserRegistration.new(Fabricate.build(:user, email: "jane@example.com", password: "jane", full_name: "Jane Doe", stripe_customer_id: customer.id), stripeToken, nil).register
        }.not_to change { ActionMailer::Base.deliveries.count }    
      end 
    end
  end  

  describe "#successful?" do
    it "returns true if register.status == :success" do
      stripeToken ='abc123' 
      invitation_token = 'xxx' 
      customer = double(:customer, successful?: true, id: 'CUST_1') 

      expect(StripeWrapper::Customer).to receive(:create).and_return(customer)
      registration = UserRegistration.new(Fabricate.build(:user, email: "jane@example.com", password: "jane", full_name: "Jane Doe", stripe_customer_id: 'CUST_1'), stripeToken, nil).register
      expect(registration).to be_successful
    end 
    
    it "returns false if register.status != :success" do
      stripeToken ='abc123' 
      customer = double(:customer, successful?: false, error_message: 'Your card was declined.')
      expect(StripeWrapper::Customer).to receive(:create).and_return(customer)
      registration = UserRegistration.new(Fabricate.build(:user, email: "jane@example.com", password: "jane", full_name: "Jane Doe"), stripeToken, nil).register
      expect(registration).not_to be_successful
    end 

  end
end