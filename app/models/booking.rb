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

class Booking < ApplicationRecord
  enum booking_type: [:daily, :once]
  validates :user_id, :booking_type, :reason, :start_date, :start_hour, :end_date, :end_hour, presence: true
  validates_date :end_date, :after => :start_date
  validates_time :end_hour, :after => :start_hour
  validates_date :start_date, :on => :create, :on_or_after => :today
  validates_date :end_date, :on => :create, :on_or_after => :today
  validates_time :start_hour, :between => ['7:30am', '5:00pm'] # On or after 7:30AM and on or before 5:00PM
  validates_time :end_hour, :between => ['8:00am', '5:30pm'] # On or after 8:00AM and on or before 5:30PM

  belongs_to :user
end
