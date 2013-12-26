# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  fname           :string(255)
#  lname           :string(255)
#  remember_token  :string(255)
#  password_digest :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  is_guest        :boolean
#  email           :string(255)
#  root_item_id    :integer
#

class User < ActiveRecord::Base
  has_many :members
  has_many :workspaces, through: :members
  has_many :groupies
  has_many :groups, through: :groupies
  has_many :viewers
  has_many :items, through: :viewers
  has_many :followers # Items being followed
  has_many :items, through: :followers
  has_many :item_contents

  validates :fname, presence: true, length: { maximum: 50 }
  validates :lname, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }

  has_secure_password validations: false  # Don't require password confirmation
  before_save { create_remember_token if (self.remember_token.blank? && self.password_digest && defined?(self.password_digest)) }
  before_save { |user| user.email = email.downcase }
  after_save do
    # Create and save a root item if needed
    break if !self.root_item_id.blank?
    user_canvas = Container.new
    user_canvas.user = self
    user_canvas.version = 0
    canvas = Item.new(is_root: true, position_top: 0, position_left: 0)
    user_canvas.item = canvas
    user_canvas.save
    canvas.save
    self.update_column(:root_item_id, canvas.id)
  end

  def display_name
    return "#{ self.fname } #{ self.lname }"
  end

  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64(32, false)
  end
end
