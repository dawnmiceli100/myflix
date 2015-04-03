class InvitationsController < ApplicationController
  before_action :require_user
  
  def new
    @invitation = Invitation.new
  end 

  def create
    @invitation = Invitation.new(invitation_params.merge!(inviter_id: current_user.id))
    if @invitation.save
      AppMailer.invite_friend(@invitation).deliver
      flash[:success] = "Your invitation has been sent to #{@invitation.invitee_name}."
      redirect_to new_invitation_path
    else
      flash[:danger] = "All fields are required."
      render :new 
    end   
  end 

  private

  def invitation_params
    params.require(:invitation).permit(:invitee_name, :invitee_email, :message)
  end
    
end