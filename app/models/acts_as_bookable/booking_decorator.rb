
ActsAsBookable::Booking.class_eval do
  validates_datetime :time_end, :after => :time_start
  validates_datetime :time_start, :on => :create, :on_or_after => lambda { Time.zone.now }
  before_create :reset_time_end

  after_create :generate_next_schedule, if: :daily?
  after_create :send_email
  after_destroy :remove_future_schedule, if: :daily?

  private

  def send_email
    @pubsub = Google::Cloud::Pubsub.new( project: ENV['PROJECT_ID'],  keyfile: ENV['GOOGLE_PUS_SUB_KEY_FILE'] )
    publish_send_mail
  end

  def get_topic
    topic_name = "send-mail-after-books"
    topic = @pubsub.topic topic_name

    topic = @pubsub.create_topic(topic_name) if topic.nil?
    topic
  end

  def publish_send_mail
    topic = get_topic
    topic.subscribe "send-mail-after-books-#{Time.now.to_i}"
    topic.publish "send mail completed",
      user_name: self.booker&.name,
      room_name: self.bookable&.name,
      title: self.title,
      start_date: self.time_start,
      end_date: self.time_end,
      daily: self.daily

  end

  def generate_next_schedule
    RoomBookingService.new(self, 7).call
  end

  def remove_future_schedule
    RoomBookingService.new(self).call
  end

  def reset_time_end
    self.time_end = self.time_end - 1.second
  end
end
