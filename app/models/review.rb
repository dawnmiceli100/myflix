class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  validates_presence_of :rating, :body
  #validates :rating, inclusion: { in: (1.0..5.0), message: "rating must be from 1 to 5" }
end