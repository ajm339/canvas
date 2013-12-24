# == Schema Information
#
# Table name: groupies
#
#  id         :integer          not null, primary key
#  group_id   :integer
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Groupie < ActiveRecord::Base
end
