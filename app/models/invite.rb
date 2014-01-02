# == Schema Information
#
# Table name: invites
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  target_fname :string(255)
#  target_lname :string(255)
#  target_email :string(255)
#  accepted     :boolean
#  code         :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  workspace_id :integer
#

class Invite < ActiveRecord::Base
  belongs_to :user
  belongs_to :workspace

  def invite
    InviteMailer.invite_email(self).deliver
  end

  def display_json
    return { id: -1, name: "#{ self.target_fname } #{ self.target_lname }" }
  end
end
