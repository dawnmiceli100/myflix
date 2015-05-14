class UsersController < ApplicationController
  before_action :require_user, only: [:show]
  
  def show
    @user = User.find(params[:id])
  end  

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    
    if @user.valid?
      card_token = params[:stripeToken]
      amount = 999

      charge = StripeWrapper::Charge.create(
        amount: amount, 
        card: card_token,
        description: "1 month charge for #{@user.email}"
      )
      if charge.successful?
        @user.save
        AppMailer.delay.welcome_new_user(@user)
        set_relationships if params[:invitation_token].present?
        flash[:success] = "You have successfully signed up for 1 month of MyFlix!"
        redirect_to sign_in_path 
      else
        flash.now[:danger] = charge.error_message
        render :new
      end  
    else
      render :new
    end    
  end

  def new_with_invitation_token
    invitation = Invitation.find_by(token: params[:token])
    if invitation
      @invitation_token = invitation.token
      @user = User.new(email: invitation.invitee_email)
      render :new
    else
      redirect_to expired_token_path
    end    
  end 

  private 
  
  def set_relationships
    invitation = Invitation.find_by(token: params[:invitation_token])
    @inviter = User.find(invitation.inviter_id)
    @user.will_follow(@inviter)
    @inviter.will_follow(@user)
    invitation.update_column(:token, nil)
  end  

  def user_params
    params.require(:user).permit(:email, :password, :full_name)
  end  
end