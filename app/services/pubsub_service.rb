class PubsubService
  def initialize
    @pubsub = Google::Cloud::Pubsub.new( project: ENV['PROJECT_ID'],  keyfile: ENV['GOOGLE_PUS_SUB_KEY_FILE'] )
  end

  def publish_books_message(booking)
    publish_send_mail(booking)
  end

  def pull_books_messages
    topic = @pubsub.topic "send-mail-after-books"
    sub = topic.subscription "send-mail-after-books-subscription"
    sub.pull
  end

  private
    def get_or_create_topic(name)
      topic = @pubsub.topic name

      topic = @pubsub.create_topic(name) if topic.nil?
      topic
    end

    def subscribe_if_not_exists(topic, name)
      subscription = topic.subscription name
      topic.subscribe( name,
          deadline: 120,
          endpoint: "#{ENV['BASE_PATH']}/api/v1/backgrounds/pull"
        ) if subscription.nil?
    end

    def publish_send_mail(booking)
      topic = get_or_create_topic "send-mail-after-books"
      subscribe_if_not_exists(topic, 'send-mail-after-books-subscription')
      topic.publish "send mail completed",
        user_name: booking.booker&.name,
        room_name: booking.bookable&.name,
        title: booking.title,
        start_date: booking.time_start,
        end_date: booking.time_end,
        daily: booking.daily
    end
end
