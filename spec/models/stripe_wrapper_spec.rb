require 'spec_helper'

describe StripeWrapper do
  describe StripeWrapper::Charge do
    describe ".create" do
      before { StripeWrapper.set_api_key }
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

      context "with valid card" do
        let(:card_number) { '4242424242424242' }

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
end  