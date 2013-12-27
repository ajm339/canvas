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

  def latest_content
    return ItemContent.find(self.latest_content_id)
  end

  def as_json(options = {})
    return super(options).merge({ latest_content: self.latest_content })
  end
end
