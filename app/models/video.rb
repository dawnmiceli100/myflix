class Video < ActiveRecord::Base
  has_many :reviews, -> { order("created_at DESC") }
  has_many :queue_items
  
  belongs_to :category

  mount_uploader :small_cover_art, SmallCoverUploader
  mount_uploader :large_cover_art, LargeCoverUploader
  
  validates :title, presence: true
  validates :description, presence: true

  def self.search_by_title(search_string)
    if search_string.blank?
      []
    else  
      where("LOWER(title) LIKE ?", "%#{search_string.downcase}%").order('created_at DESC')
    end  
  end  

  def average_rating
    if self.reviews.exists?
      rating = reviews.average(:rating).round(1)
    else
      rating = 0   
    end
  end 

  def in_users_queue?(user)
    QueueItem.where({ video_id: self.id, user_id: user.id }).exists?
  end  
end