# == Schema Information
#
# Table name: groups
#
#  id           :integer          not null, primary key
#  workspace_id :integer
#  name         :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

class Group < ActiveRecord::Base
  belongs_to :workspace
  has_many :groupies
  has_many :users, through: :groupie
end
