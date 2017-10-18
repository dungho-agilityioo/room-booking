# == Schema Information
#
# Table name: rooms
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class BookingSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :start_date, :end_date, :state

  belongs_to :user
  belongs_to :room
end
