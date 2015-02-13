class QueueItemsController < ApplicationController
  before_action :require_user

  def index
    @queue_items = current_user.queue_items
  end  

  def create
    video = Video.find(params[:video_id])
    
    if !video_in_users_queue?(video)
      add_video_to_queue(video)
    else
      flash[:info] = "#{video.title} is already in your queue."  
    end 

    redirect_to my_queue_path    
  end 

  def destroy
    item = QueueItem.find(params[:id])
    item.destroy if item.user_id == current_user.id
    reorder_queue_items
    redirect_to my_queue_path 
  end  

  private

  def video_in_users_queue?(video)
    current_user.queue_items.where(video_id: video.id).exists?
  end

  def add_video_to_queue(video)
    new_item_position = current_user.queue_items.count + 1
    @queue_item = QueueItem.new(queue_position: new_item_position, video: video, user: current_user)
    
    if @queue_item.save
      flash[:success] = "#{video.title} has been added to your queue."
    else
      flash[:danger] = "An error occurred adding the video to your queue." 
    end 
  end  
   
  def reorder_queue_items
    new_position = 1
    @current_user.queue_items.each do |item|
      item.queue_position = new_position
      item.save
      new_position += 1
    end
  end 

  def queue_item_params
    params.require(:queue_item).permit(:queue_position)
  end 
end