class User < ActiveRecord:: Base
  has_many :reviews
  has_many :queue_items, -> { order("queue_position") }
  
  validates_presence_of :email, :password, :full_name
  validates :email, uniqueness: true

  has_secure_password validations: false

  def reorder_queue_items
    new_position = 1
    queue_items.each do |item|
      item.queue_position = new_position
      item.save
      new_position += 1
    end
  end 
end