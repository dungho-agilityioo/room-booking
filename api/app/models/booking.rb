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
  before_save :set_state, :check_duplicate

  private
  def check_duplicate
    if duplicated?
      raise ExceptionHandler::BookingDuplicate.new('Booking is overlapping')
    end
  end

  def set_state
    self.state = overlaps? ? :conflict : :available
  end

  def send_email
    PubsubService.new.publish_books_message(self)
  end

  def generate_next_schedule
    # RoomBookingService.new(self, 7).call
  end

  def remove_future_schedule
    # RoomBookingService.new(self).call
  end

  # Check if a given interval overlaps this interval
  def overlaps?
    overlap_query.count() > 0
  end

  # Check duplicate booking of user
  def duplicated?
    overlap_query
    .where(user_id: user_id).count() > 0
  end

  def overlap_query
    query = Booking.where(room_id: room_id)
      .where("end_date::TIMESTAMP >= ?", start_date)
      .where("start_date::TIMESTAMP < ?", end_date)

    query = query.where.not(id: id) unless new_record?
    query
  end
end
