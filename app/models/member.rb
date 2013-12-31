# == Schema Information
#
# Table name: members
#
#  id           :integer          not null, primary key
#  workspace_id :integer
#  user_id      :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class Member < ActiveRecord::Base
  belongs_to :user
  belongs_to :workspace
end
