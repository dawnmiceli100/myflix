require 'spec_helper'

describe "Create payment for stripe charge" do
  context "with successful charge" do
    
    let(:event_data) do
      {
        "id" => "evt_167oByKs0xJP6zPXYV0YwePC",
        "created" => 1432908634,
        "livemode" => false,
        "type" => "charge.succeeded",
        "data" => {
          "object" => {
            "id" => "ch_167oByKs0xJP6zPXbHCs2K0K",
            "object" => "charge",
            "created" => 1432908634,
            "livemode" => false,
            "paid" => true,
            "status" => "succeeded",
            "amount" => 999,
            "currency" => "usd",
            "refunded" => false,
            "source" => {
              "id" => "card_167oBwKs0xJP6zPXuy8sYyp4",
              "object" => "card",
              "last4" => "4242",
              "brand" => "Visa",
              "funding" => "credit",
              "exp_month" => 5,
              "exp_year" => 2017,
              "fingerprint" => "53HU0yi9q9LOctGv",
              "country" => "US",
              "name" => nil,
              "address_line1" => nil,
              "address_line2" => nil,
              "address_city" => nil,
              "address_state" => nil,
              "address_zip" => nil,
              "address_country" => nil,
              "cvc_check" => "pass",
              "address_line1_check" => nil,
              "address_zip_check" => nil,
              "dynamic_last4" => nil,
              "metadata" => {},
              "customer" => "cus_6KT8sZEpqcd3q4"
            },
            "captured" => true,
            "balance_transaction" => "txn_167oByKs0xJP6zPXjjwmAnzo",
            "failure_message" => nil,
            "failure_code" => nil,
            "amount_refunded" => 0,
            "customer" => "cus_6KT8sZEpqcd3q4",
            "invoice" => "in_167oBxKs0xJP6zPXdporhEyH",
            "description" => nil,
            "dispute" => nil,
            "metadata" => {},
            "statement_descriptor" => nil,
            "fraud_details" => {},
            "receipt_email" => nil,
            "receipt_number" => nil,
            "shipping" => nil,
            "destination" => nil,
            "application_fee" => nil,
            "refunds" => {
              "object" => "list",
              "total_count" => 0,
              "has_more" => false,
              "url" => "/v1/charges/ch_167oByKs0xJP6zPXbHCs2K0K/refunds",
              "data" => []
            }
          }
        },
        "object" => "event",
        "pending_webhooks" => 1,
        "request" => "iar_6KT87wMGqLjXDg",
        "api_version" => "2015-04-07"
      }
    end

    before do
      User.create(email: "jane@example.com", password: "jane", full_name: "Jane Doe", stripe_customer_id: event_data["data"]["object"]["customer"])
      post "/stripe_events", event_data 
    end
      
    it "creates a payment using the webhook from stripe", :vcr do  
      expect(Payment.count).to eq(1)
    end 

    it "associates the payment with the correct user", :vcr do
      expect(Payment.first.user.stripe_customer_id).to eq(event_data["data"]["object"]["customer"])
    end 

    it "creates a payment with the correct amount", :vcr do
      expect(Payment.first.amount).to eq(event_data["data"]["object"]["amount"])
    end 

    it "creates a payment with the correct stripe_charge_id", :vcr do
      expect(Payment.first.stripe_charge_id).to eq(event_data["data"]["object"]["id"])
    end 
  end
end  