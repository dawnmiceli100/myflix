class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  validates_uniqueness_of :video_id, scope: :user_id
  validates_uniqueness_of :queue_position, scope: :user_id

  validates_numericality_of :queue_position, { only_integer: true } 

  delegate :category, to: :video
  delegate :title, to: :video, prefix: :video

  def rating
    review = Review.where(user_id: user.id, video_id: video.id).first
    review.rating if review
  end 

  def category_name
    category.name
  end 
end  