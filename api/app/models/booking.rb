class Booking <  ApplicationRecord
  enum state: [:available, :conflict]

  belongs_to :user
  belongs_to :room

  validates_datetime :end_date, :after => :start_date
  validates_datetime :start_date, :on => :create, :on_or_after => lambda { Time.zone.now }
  validates_presence_of :title, :room_id, :user_id, :start_date, :end_date

  after_create :generate_next_schedule, if: :daily?
  after_create :send_email unless Rails.env.test?
  after_destroy :remove_future_schedule, if: :daily?
  before_save :check_duplicate
  before_create :set_state

  class << self
    # Check if a given interval overlaps this interval
    def overlaps?(booking)
      overlap_query(booking).count() > 0
    end

    # Check duplicate booking of user
    def duplicate?(booking)
      overlap_query(booking)
      .where(user_id: booking.user_id).count() > 0
    end

    def overlap_query(booking)
      query = self.where(room_id: booking.room_id)
      .where("end_date::TIMESTAMP >= ?", booking.start_date)
      .where("start_date::TIMESTAMP < ?", booking.end_date)

      query = query.where.not(id: booking.id) unless booking.new_record?
      query
    end

  end

  private
  def check_duplicate
    if Booking.duplicate?(self)
      raise ExceptionHandler::BookingDuplicate.new('Booking is overlapping')
    end
  end

  def set_state
    self.state = Booking.overlaps?(self) ? :conflict : :available
  end

  def send_email
    PubsubService.new.publish_books_message(self)
  end

  def generate_next_schedule
    RoomBookingService.new(self, 7).call
  end

  def remove_future_schedule
    RoomBookingService.new(self).call
  end

end
