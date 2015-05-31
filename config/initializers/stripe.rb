Stripe.api_key = ENV['STRIPE_SECRET_KEY']

StripeEvent.configure do |events|
  events.subscribe 'charge.succeeded' do |event|
    user = User.find_by(stripe_customer_id: event.data.object.customer)
    Payment.create(user: user, amount: event.data.object.amount, stripe_charge_id: event.data.object.id)
  end

  events.subscribe 'charge.failed' do |event|
    user = User.find_by(stripe_customer_id: event.data.object.customer)
    user.lock!
    user.save
    AppMailer.delay.notify_user_of_payment_failure(user)
  end
end