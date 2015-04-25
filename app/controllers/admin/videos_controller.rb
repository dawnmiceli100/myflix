class Admin::VideosController < ApplicationController
  before_action :require_user
  before_action :require_admin

  def new
    @video = Video.new
  end 

  def create
    @video = Video.new(video_params)

    if @video.save
      flash[:success]  = "#{@video.title} has been successfully added."
      redirect_to new_admin_video_path
    else
      flash[:danger] = "You must enter a title and description for the video."
      render 'new'
    end

  end 

  private

  def video_params
    params.require(:video).permit(:title, :description, :small_cover_art, :large_cover_art, :category_id)
  end    

  def require_admin
    if !current_user.admin?
      flash[:danger] = "You do not have permission to do that."
      redirect_to home_path
    end
  end  

end