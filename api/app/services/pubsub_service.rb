class PubsubService
  def initialize
    @pubsub = Google::Cloud::Pubsub.new( project: ENV['PROJECT_ID'],  keyfile: ENV['GOOGLE_PUS_SUB_KEY_FILE'] )
  end

  def publish_books_message(booking)
    publish_send_mail(booking)
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
          endpoint: "#{ENV['BASE_PATH']}/_ah/push-handlers/push/#{ENV['PUBSUB_VERIFICATION_TOKEN']}"
        ) if subscription.nil?
    end

    def publish_send_mail(booking)
      topic = get_or_create_topic ENV['PUBSUB_TOPIC_SEND_MAIL']
      subscribe_if_not_exists(topic, "#{ENV['PUBSUB_TOPIC_SEND_MAIL']}-subscription")
      topic.publish "send mail completed",
        user_name: booking.booker&.name,
        room_name: booking.bookable&.name,
        title: booking.title,
        start_date: booking.time_start,
        end_date: booking.time_end,
        daily: booking.daily
    end
end
