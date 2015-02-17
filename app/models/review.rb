class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  #validates_presence_of :rating, :body
  validates_presence_of :rating
  validates_presence_of :body
end