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
      amount = 999
      registration = UserRegistration.new(@user, params[:stripeToken], amount, params[:invitation_token]).register
      if registration.successful?
        flash[:success] = "You have successfully signed up for 1 month of MyFlix!"
        redirect_to sign_in_path 
      else
        flash.now[:danger] = registration.error_message
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
  
  def user_params
    params.require(:user).permit(:email, :password, :full_name)
  end  
end