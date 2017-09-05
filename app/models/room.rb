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
  acts_as_bookable time_type: :range, bookable_across_occurrences: true, capacity_type: :closed
	validates_presence_of :name
  after_initialize :set_default_schedule, :if => :new_record?

  private

  def set_default_schedule
    self.schedule = IceCube::Schedule.new(Date.today, duration: 1.day)
    self.schedule.add_recurrence_rule IceCube::Rule.weekly.day(:monday, :tuesday, :wednesday, :thursday, :friday)
    self.capacity = 1
  end

end
