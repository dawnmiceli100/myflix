module Tokenable
  extend ActiveSupport::Concern

  private

  def generate_token(column=nil) 
    token = column || :token
    self[token] = SecureRandom.urlsafe_base64
  end   
end