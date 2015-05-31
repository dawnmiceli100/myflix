class SessionsController < ApplicationController
  def new
    redirect_to home_path if signed_in?  
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      if user.locked?
        flash[:danger] = "Your account has been locked. Please contact MyFlix to unlock your account."
        redirect_to root_path
      else  
        session[:user_id] = user.id
        flash[:success] = "You have successfully signed in."
        redirect_to home_path
      end  
    else
      flash[:error] = "Your email address and/or password are incorrect." 
      redirect_to sign_in_path
    end   
  end 

  def destroy
    session[:user_id] = nil
    flash[:success] = "Your have signed out."
    redirect_to root_path
  end 
end