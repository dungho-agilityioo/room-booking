# == Schema Information
#
# Table name: projects
#
#  id         :integer          not null, primary key
#  name       :string
#  status     :integer          default("active")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :name, :status
  has_many :users, through: :user_projects
end
