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

class BookingSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :start_date, :end_date, :state, :user, :room

  def user
    object.user.slice(:id, :email, :name, :first_name, :last_name)
  end

  def room
    object.room.slice(:id, :name)
  end
end
