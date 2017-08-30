# == Schema Information
#
# Table name: bookings
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  project_id   :integer
#  booking_type :integer
#  reason       :text
#  start_date   :date
#  start_hour   :time
#  end_date     :date
#  end_hour     :time
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class BookingSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :project_id, :booking_type, :reason, :start_date, :start_hour, :end_date, :end_hour
end
