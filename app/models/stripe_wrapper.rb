module StripeWrapper
  class Charge
    attr_reader :response, :status

    def initialize(response, status)
      @response = response
      @status = status
    end

    def self.create(options={})
      begin
        response = Stripe::Charge.create(
          amount: options[:amount], 
          currency: 'usd', 
          card: options[:card],
          description: options[:description]
          )
        new(response, :success)
      rescue Stripe::CardError => e
        new(e, :error)
      end
    end

    def successful?
      status == :success
    end

    def error?
      status == :error
    end  
    
    def error_message
      response.message
    end  
  end

  class Customer
    attr_reader :response, :status

    def initialize(response, status)
      @response = response
      @status = status
    end

    def self.create(options={})
      begin
        response = Stripe::Customer.create(
          source: options[:source],
          plan: "standard",
          email: options[:email]
          )
        new(response, :success)
      rescue Stripe::CardError => e
        new(e, :error)
      end
    end

    def successful?
      status == :success
    end

    def error?
      status == :error
    end  
    
    def error_message
      response.message
    end 

    def id
      response.id
    end   
  end

end