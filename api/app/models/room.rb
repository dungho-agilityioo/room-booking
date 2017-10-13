# == Schema Information
#
# Table name: rooms
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  schedule   :text
#  capacity   :integer
#

class Room < ApplicationRecord
  has_many :bookings
  has_many :users, through: :bookings
	validates_presence_of :name

end
