class VideoDecorator < Draper::Decorator
  delegate_all

  def average_rating
    if object.reviews.exists?
      "Average Rating: #{object.reviews.average(:rating).round(1)} Stars"
    else
      "Average Rating: N/A"   
    end
  end 
end