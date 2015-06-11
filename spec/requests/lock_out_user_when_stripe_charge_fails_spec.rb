require 'spec_helper'

describe "Lock out user when stripe charge fails" do
  let(:event_data) do
    {
      "id" => "evt_168arzKs0xJP6zPXXoIdDivC",
      "created" => 1433095751,
      "livemode" => false,
      "type" => "charge.failed",
      "data" => {
        "object" => {
          "id" => "ch_168arzKs0xJP6zPXHUTnkIRj",
          "object" => "charge",
          "created" => 1433095751,
          "livemode" => false,
          "paid" => false,
          "status" => "failed",
          "amount" => 999,
          "currency" => "usd",
          "refunded" => false,
          "source" => {
            "id" => "card_168apsKs0xJP6zPXjeiEUdon",
            "object" => "card",
            "last4" => "0341",
            "brand" => "Visa",
            "funding" => "credit",
            "exp_month" => 5,
            "exp_year" => 2018,
            "fingerprint" => "De4Yjf8XSp9d3vWX",
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
            "customer" => "cus_6KbX0KXUoCpZjH"
          },
          "captured" => false,
          "balance_transaction" => nil,
          "failure_message" => "Your card was declined.",
          "failure_code" => "card_declined",
          "amount_refunded" => 0,
          "customer" => "cus_6KbX0KXUoCpZjH",
          "invoice" => nil,
          "description" => "test failed charge",
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
            "url" => "/v1/charges/ch_168arzKs0xJP6zPXHUTnkIRj/refunds",
            "data" => []
          }
        }
      },
      "object" => "event",
      "pending_webhooks" => 1,
      "request" => "iar_6LHQOjYGRIqaZ3",
      "api_version" => "2015-04-07"
    }
  end

  before do
    User.create(email: "jane@example.com", password: "jane", full_name: "Jane Doe", stripe_customer_id: event_data["data"]["object"]["customer"], locked: false)
    post "/stripe_events", event_data 
  end

  after { ActionMailer::Base.deliveries.clear }

  let(:jane) { User.find_by(stripe_customer_id: event_data["data"]["object"]["customer"]) }
    
  it "locks the user's myflix account", :vcr do  
    expect(jane).to be_locked
  end 

  it "sends out the account locked email" do
    expect(ActionMailer::Base.deliveries).not_to be_blank  
  end 

  it "sends the account locked email to the correct user" do
    email = ActionMailer::Base.deliveries.last
    expect(email.to).to eq(["jane@example.com"])    
  end 

  it "sends the welcome email with the right content" do
    email = ActionMailer::Base.deliveries.last
    expect(email.body).to include("Jane Doe")    
  end 
end  