class Video < ActiveRecord::Base
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
end