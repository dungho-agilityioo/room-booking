# == Schema Information
#
# Table name: rooms
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class RoomSerializer < ActiveModel::Serializer
  attributes :id, :name, :created_at, :updated_at
end
