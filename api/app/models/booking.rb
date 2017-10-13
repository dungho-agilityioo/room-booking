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
  before_save :check_overlap_and_set_state

  # scope :by_room, ->(room_id) { where(bookable_id: room_id) }

  private

  def send_email
    PubsubService.new.publish_books_message(self)
  end

  def generate_next_schedule
    RoomBookingService.new(self, 7).call
  end

  def remove_future_schedule
    RoomBookingService.new(self).call
  end

  # check room overlap and reset state
  def check_overlap_and_set_state

  end
end
