class ResetPasswordsController < ApplicationController
  
  def new
  end

  def create
    user = User.where(email: params[:email]).first
    if user
      user.initiate_password_reset
      render :email_sent
    else 
      flash.now[:danger] = "The email address you entered is not valid."
      render :new
    end 
  end 

  def edit
    @user = User.find_by_reset_token(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if params[:user][:password].blank?
      flash[:danger] = "Your password can't be blank."
      render :edit 
    elsif @user.reset_sent_at < 2.hours.ago
      flash[:danger] = "Your password reset has expired." 
      redirect_to new_reset_password_path 
    else @user.update_attributes(user_params)
      flash[:success] = "Your password has been reset!"
      redirect_to sign_in_path 
    end      
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :full_name)
  end  


end