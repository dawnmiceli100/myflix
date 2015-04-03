class Invitation < ActiveRecord::Base
  include Tokenable

  belongs_to :inviter, class_name: "User"

  before_create :generate_token

  validates_presence_of :invitee_name
  validates_presence_of :invitee_email
  validates_presence_of :message
end