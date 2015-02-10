class ReviewsController < ApplicationController 
  before_action :require_user

  def create
    @video = Video.find(params[:video_id])
    @review = @video.reviews.new(review_params)
    @review.user = current_user

    if @review.save
      flash[:success] = "Your review has been saved."
      redirect_to video_path(@video)
    else
      flash[:danger] = "You must enter a rating and a review body."
      @reviews = @video.reviews.reload
      render 'videos/show'
    end    
  end  

  def review_params
    params.require(:review).permit(:rating, :body)
  end  
end