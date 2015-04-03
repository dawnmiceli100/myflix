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
    
    if @user.save
      AppMailer.welcome_new_user(@user).deliver
      set_relationships if params[:invitation_token].present?
      redirect_to sign_in_path
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