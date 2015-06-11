class Admin::VideosController < AdminsController

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
    params.require(:video).permit(:title, :description, :small_cover_art, :large_cover_art, :video_url, :category_id)
  end    

end