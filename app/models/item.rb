# == Schema Information
#
# Table name: items
#
#  id                :integer          not null, primary key
#  position_top      :integer
#  position_left     :integer
#  created_at        :datetime
#  updated_at        :datetime
#  is_root           :boolean
#  latest_content_id :integer
#  creator_id        :integer
#

class Item < ActiveRecord::Base
  has_many :viewers
  has_many :users, through: :viewers
  has_many :followers
  has_many :users, through: :followers
  has_many :item_contents
  # Self-referential association
  # http://railscasts.com/episodes/163-self-referential-association
  has_many :collections
  has_many :items, through: :collections
  has_many :inverse_collections, class_name: 'Collection', foreign_key: 'parent_id'
  has_many :inverse_items, through: :inverse_collections, source: :item

  validates :creator_id, presence: true
  # validates :latest_content_id, presence: true
  before_save { |i| i.position_top = 0 if i.position_top.nil? }
  before_save { |i| i.position_left = 0 if i.position_left.nil? }

  def self.create_with_params_and_parent_for_user(item_params, parent_id, user_id)
    # Only for non-root items
    content_class = item_params[:latest_content][:type]
    return false if !content_class.casecmp('Note').zero?  # Only allow notes for now
    n = Note.new
    n.user = User.find(user_id)
    n.version = 0
    i = Item.create(is_root: false, position_top: item_params[:position_top], position_left: item_params[:position_left], creator_id: user_id)
    n.item = i
    n.save  # TODO: Maybe i should be saved before n? Same in User.rb
    i.latest_content_id = n.id
    i.save
    i.delete and n.delete and return false if parent.blank?
    Collection.create(parent_id: parent_id, item_id: i.id)
    Follower.create(user_id: user_id, item_id: i.id, is_owner: true, can_edit: true)
    Permission.create(user_id: user_id, item_id: i.id, can_see: true)
    return i
  end

  def latest_content
    return ItemContent.find(self.latest_content_id)
  end

  def creator
    return User.find(self.creator_id)
  end
  def children
    return self.inverse_items.to_a
  end

  def following_users
    return self.users.to_a
  end

  def as_json(options = {})
    return super(options).merge({ latest_content: self.latest_content })
  end
  def as_json_with_children(recurse_depth = 1)
    if recurse_depth > 0
      children_json = []
      self.children.each do |c| children_json << c.as_json_with_children(recurse_depth - 1) end
    end
    return self.as_json().merge({ latest_content: self.latest_content, children: children_json || [] })
  end
end
