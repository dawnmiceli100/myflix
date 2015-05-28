class UserRegistration
  attr_reader :user, :card_token, :amount, :invitation_token
  attr_accessor :status, :error_message
  
  def initialize(user, card_token, invitation_token=nil)
    @user = user
    @card_token = card_token
    @invitation_token = invitation_token
  end 

  def register
    customer = StripeWrapper::Customer.create(
      source: card_token,
      email: user.email
    )
    if customer.successful?
      user.stripe_customer_id = customer.id
      user.save
      AppMailer.delay.welcome_new_user(user)
      set_relationships if invitation_token.present?
      self.status = :success
    else
      self.status = :error
      self.error_message = customer.error_message
    end 
    self  
  end 

  def successful?
    status == :success
  end  

  private 
  
  def set_relationships
    invitation = Invitation.find_by(token: invitation_token)
    @inviter = User.find(invitation.inviter_id)
    user.will_follow(@inviter)
    @inviter.will_follow(user)
    invitation.update_column(:token, nil)
  end  
end