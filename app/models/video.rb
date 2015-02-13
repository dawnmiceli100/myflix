class Video < ActiveRecord::Base
  has_many :reviews, -> { order("created_at DESC") }
  has_many :queue_items
  
  belongs_to :category
  
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
end