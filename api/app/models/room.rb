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
  before_destroy :check_for_booking

  private

  def check_for_booking
    if bookings.any?
      raise ActiveRecord::RecordNotDestroyed, 'cannot delete room that has already been booking'
    end
  end

end
