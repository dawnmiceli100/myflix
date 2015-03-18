class ResetPasswordsController < ApplicationController
  
  def create
    user = User.find_by(email: params[:email])
    user.initiate_password_reset if user
    render :email_sent
  end 

  def edit
    @user = User.find_by(reset_token: params[:id])
  end

  def update
    @user = User.find(params[:id])
    if params[:user][:password].blank?
      flash.now[:danger] = "Your password can't be blank."
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