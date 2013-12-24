# == Schema Information
#
# Table name: workspaces
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Workspace < ActiveRecord::Base
  has_many :groups
  has_many :members
  has_many :users, through: :members
end
