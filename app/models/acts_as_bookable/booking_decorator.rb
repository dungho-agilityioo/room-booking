
ActsAsBookable::Booking.class_eval do
  validates_datetime :time_end, :after => :time_start
  validates_datetime :time_start, :on => :create, :on_or_after => lambda { Time.now + 7.hours }
  before_create :reset_time_end

  after_create :gen_next_schedule, if: :daily?
  after_create :send_email
  after_destroy :remove_future_schedule, if: :daily?

  private

  def send_email
    UserMailer.room_booking({params: self}).deliver_later
  end

  def gen_next_schedule
    RoomBookingService.new(self, 7).call
  end

  def remove_future_schedule
    RoomBookingService.new(self).call
  end

  def reset_time_end
    self.time_end = self.time_end - 1.second
  end

end
