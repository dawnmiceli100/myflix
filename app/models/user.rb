class User < ActiveRecord:: Base
  has_many :reviews, -> { order(created_at: :desc) }
  has_many :queue_items, -> { order(:queue_position) }

  #self join through relationships
  has_many :following_relationships, class_name: "Relationship", foreign_key: "follower_id"
  has_many :followed_by_relationships, class_name: "Relationship", foreign_key: "followed_id"
  
  validates_presence_of :email, :password, :full_name
  validates :email, uniqueness: true

  has_secure_password validations: false

  def reorder_queue_items
    queue_items.each_with_index do |item, index|
      item.update_attributes!(queue_position: index + 1)
    end  
  end 

  def follows?(another_user)
    following_relationships.map{ |relationship| relationship.followed }.include?(another_user)  
  end  

  def can_follow?(another_user)
    !(self.follows?(another_user) || another_user == self)
  end  
end