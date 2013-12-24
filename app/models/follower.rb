# == Schema Information
#
# Table name: followers
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  item_id    :integer
#  is_owner   :boolean
#  can_edit   :boolean
#  created_at :datetime
#  updated_at :datetime
#

class Follower < ActiveRecord::Base
end
