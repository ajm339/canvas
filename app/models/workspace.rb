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

  def self.create_with_user_id(workspace_params, user_id)
    w = Workspace.create(workspace_params)
    m = Member.create(workspace_id: w.id, user_id: user_id)
    return w
  end

  def as_json(options={})
    super.merge(members: self.users.map(&:display_json))
  end
end
