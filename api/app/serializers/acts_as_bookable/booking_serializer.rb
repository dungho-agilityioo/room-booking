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

class ActsAsBookable::BookingSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :time_start, :time_end, :user, :room

  def user
    object.booker.slice(:id, :email, :name, :first_name, :last_name)
  end

  def room
    object.bookable.slice(:id, :name)
  end
end
