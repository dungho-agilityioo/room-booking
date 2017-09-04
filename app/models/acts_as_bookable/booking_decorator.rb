
ActsAsBookable::Booking.class_eval do
  validate :limit_time
  validates_datetime :time_end, :after => :time_start
  validates_datetime :time_start, :on => :create, :on_or_after => lambda { Time.now + 7.hours }
  before_create :reset_time_end

  after_create :gen_next_schedule, if: :daily?

  private

  def gen_next_schedule
    RoomBookingService.new(self, 7).call
  end

  def reset_time_end
    self.time_end = self.time_end - 1.second
  end

  def limit_time

    if self.time_start < time_start_limit || self.time_end > time_end_limit
      raise (
        ActsAsBookable::AvailabilityError.new(
          ActsAsBookable::T.er(
            '.availability.unavailable_interval',
            model: 'Room',
            time_start: Time.zone.parse(self.time_start.to_s).utc,
            time_end: Time.zone.parse(self.time_end.to_s).utc
          )
        )
      )
    end
  end

  def time_start_limit
    DateTime.new(self.time_start.year, self.time_start.month, self.time_start.day, 7, 30)
  end

  def time_end_limit
    DateTime.new(self.time_end.year, self.time_end.month, self.time_end.day, 17, 30)
  end
end
