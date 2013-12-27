# == Schema Information
#
# Table name: item_contents
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  version    :integer
#  item_id    :integer
#  type       :string(255)
#  content    :text
#  url        :string(255)
#  name       :string(255)
#  location   :string(255)
#  start_time :datetime
#  is_all_day :boolean
#  end_time   :datetime
#  alert      :integer
#  is_checked :boolean
#  order      :integer
#  created_at :datetime
#  updated_at :datetime
#

class ItemContent < ActiveRecord::Base
  belongs_to :item
  belongs_to :user

  validates :item, presence: true
  validates :user, presence: true

  after_create do
    self.item.latest_content_id = self.id
    self.item.save
  end

  def creator
    return self.user
  end

  def as_json(options = {})
    return super(options).merge({ type: self.type })
  end
end
