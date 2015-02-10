class User < ActiveRecord:: Base
  has_many :reviews
  
  validates_presence_of :email, :password, :full_name
  validates :email, uniqueness: true

  has_secure_password validations: false
end