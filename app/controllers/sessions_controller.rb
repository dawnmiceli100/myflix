class SessionsController < ApplicationController
  def new
    if signed_in?
      redirect_to home_path
    end  
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "You have successfully signed in."
      redirect_to home_path
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