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
  attributes :id, :title, :description, :time_start, :time_end

  belongs_to :bookable, polymorphic: true
  belongs_to :booker,   polymorphic: true
end
