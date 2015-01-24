class PagesController < ApplicationController
  def front
    if signed_in?
      redirect_to home_path
    end  
  end
end