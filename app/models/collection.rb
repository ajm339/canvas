# == Schema Information
#
# Table name: collections
#
#  id         :integer          not null, primary key
#  parent_id  :integer
#  item_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Collection < ActiveRecord::Base
  belongs_to :item
  belongs_to :collection, class_name: 'Item'
end
