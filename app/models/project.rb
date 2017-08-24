# == Schema Information
#
# Table name: projects
#
#  id         :integer          not null, primary key
#  name       :string
#  status     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Project < ApplicationRecord

  validates_presence_of :name
  enum status: [:active, :inactive]

end
