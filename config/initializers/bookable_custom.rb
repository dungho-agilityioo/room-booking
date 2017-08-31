
ActsAsBookable::Booking.class_eval do
  validates :title, :description, presence: true
  # validate :limit_time

  private

  def limit_time

    time_start_limit = DateTime.new(self.time_start.year, self.time_start.month, self.time_start.day, 7, 30)
    time_end_limit = DateTime.new(self.time_end.year, self.time_end.month, self.time_end.day, 17, 30)

    if self.time_start < time_start_limit || self.time_end > time_end_limit
      raise (ActsAsBookable::AvailabilityError.new( ActsAsBookable::T.er('.availability.unavailable_interval', model: 'Room', time_start: self.time_start, time_end: self.time_end)))
    end
  end
end
