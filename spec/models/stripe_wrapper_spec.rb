require 'spec_helper'

describe StripeWrapper do
  describe StripeWrapper::Charge do
    describe ".create" do
      context "with valid card" do
        let(:card_number) { '4242424242424242' }
        let(:card_token) do
          Stripe::Token.create(
            card: {
              number: card_number,
              exp_month: 12,
              exp_year: 2017,
              cvc: '123'
            },
          ).id 
        end 

        it "charges the card", :vcr do
          charge = StripeWrapper::Charge.create(
            amount: 999,
            card: card_token,
            description: 'test charge with valid card'
          )
          expect(charge).to be_successful
          expect(charge.response.amount).to eq(999)
        end 
      end 

      context "with invalid card" do
        let(:card_number) { '4000000000000002' }
        let(:card_token) do
          Stripe::Token.create(
            card: {
              number: card_number,
              exp_month: 12,
              exp_year: 2017,
              cvc: '123'
            },
          ).id 
        end 
        let(:charge) { StripeWrapper::Charge.create(
          amount: 999,
          card: card_token,
          description: 'test with invalid card'
        ) }

        it "does not charge the card", :vcr do
          expect(charge).to be_error
        end
        
        it "returns the 'card declined' message", :vcr do
          expect(charge.error_message).to eq("Your card was declined.")
        end  
      end      
    end    
  end

  describe StripeWrapper::Customer do
    describe ".create" do
      context "with valid card" do
        let(:card_number) { '4242424242424242' }
        let(:card_token) do
          Stripe::Token.create(
            card: {
              number: card_number,
              exp_month: 12,
              exp_year: 2017,
              cvc: '123'
            },
          ).id 
        end 

        it "creates the stripe customer", :vcr do
          customer = StripeWrapper::Customer.create(
            source: card_token,
            email: 'janedoe@example.com'
          )
          expect(customer).to be_successful
          expect(customer.response.email).to eq('janedoe@example.com')
        end 
      end 

      context "with invalid card" do
        let(:card_number) { '4000000000000002' }
        let(:card_token) do
          Stripe::Token.create(
            card: {
              number: card_number,
              exp_month: 12,
              exp_year: 2017,
              cvc: '123'
            },
          ).id 
          end 
        let(:customer) { StripeWrapper::Customer.create(
          source: card_token,
          email: 'janedoe@example.com'
        ) }

        it "does not create the customer", :vcr do
          expect(customer).to be_error
        end
        
        it "returns the 'card declined' message", :vcr do
          expect(customer.error_message).to eq("Your card was declined.")
        end  
      end      
    end    
  end
end  