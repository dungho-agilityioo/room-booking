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

class Project < ApplicationRecord

  validates_presence_of :name
  enum status: [:active, :inactive]

  has_many :user_projects
  has_many :users, through: :user_projects

  scope :active, -> { where(status: :active) }
end
