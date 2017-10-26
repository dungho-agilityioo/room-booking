class Booking <  ApplicationRecord
  include ActiveModel::Dirty

  enum state: [:available, :conflict]

  belongs_to :user
  belongs_to :room

  validates_datetime :end_date, :after => :start_date
  validates_datetime :start_date, :on => :create, :on_or_after => lambda { Time.zone.now }
  validates_presence_of :title, :room_id, :user_id, :start_date, :end_date

  after_create :generate_next_booking, if: :daily?
  after_create :send_email_booking, :send_mail_reminder unless Rails.env.test?
  after_destroy :remove_future_booking, if: :daily?
  before_save :check_duplicate
  before_create :set_state
  after_update :change_state, if: :state_changed?
  after_update :send_mail_reminder, if: :state_changed?

  # Check if a given interval overlaps this interval
  def overlaps?
    overlap_query.count() > 0
  end

  private
  def check_duplicate
    if duplicated?
      raise ExceptionHandler::BookingDuplicate.new(I18n.t('errors.messages.booking_overlap'))
    end
  end

  def set_state
    self.state = overlaps? ? :conflict : :available
  end

  def send_email_booking
    # publish message to send email after booking
    MessagingService.instance.publish(BookingSerializer.new(self).to_json)
  end

  def send_mail_reminder
    if available?
      message_service = MessagingService.instance
      # message_service.delete_delayed_queue(id)
      # publish message to send email reminder
      message_service.publish_delayed(BookingSerializer.new(self).to_json)
    end
  end

  def change_state
    # ensure state change to conflict to available
    return if conflict?

    # message_service = MessagingService.instance
    overlaps = overlap_query

    if overlaps.present?
      overlaps.each do |booking|
        booking.update_column("state", :conflict)
        # message_service.delete_delayed_queue(booking.id)
      end
    end
  end

  # Booking before 7 days if booking is daily
  def generate_next_booking
    BookingService.create_next_booking(self, 7)
  end

  # Remove all future booking if delete a daily booking
  def remove_future_booking
    BookingService.remove_future_booking(self)
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

    new_record? && query || query.where.not(id: id)
  end
end
