class User < ActiveRecord:: Base
  has_many :reviews
  has_many :queue_items, -> { order("queue_position") }
  
  validates_presence_of :email, :password, :full_name
  validates :email, uniqueness: true

  has_secure_password validations: false

  def reorder_queue_items
    queue_items.each_with_index do |item, index|
      item.update_attributes!(queue_position: index + 1)
    end  
  end 
end