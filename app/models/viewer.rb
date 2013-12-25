# == Schema Information
#
# Table name: viewers
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  item_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Viewer < ActiveRecord::Base
  belongs_to :user
  belongs_to :item
end
