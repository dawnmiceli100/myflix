class RelationshipsController < ApplicationController
  before_action :require_user

  def index
    @relationships = current_user.following_relationships
  end 

  def create
    followed = User.find(params[:followed_id])
    if current_user.can_follow?(followed)
      relationship = Relationship.create(follower: current_user, followed: followed)
      flash[:success] = "You are now following #{followed.full_name}." 
    else  
      flash[:danger] = "You cannot follow this user."     
    end  
    redirect_to people_path  
  end  

  def destroy
    relationship = Relationship.find(params[:id])
    followed_name = relationship.followed.full_name
    relationship.destroy if relationship.follower == current_user
    flash[:success] = "You are no longer following #{followed_name}."
    redirect_to people_path
  end 
end