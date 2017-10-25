class MessagingService
  include Singleton
  DELAYED_REMINDER_QUEUE = 'amqp.bookings.reminder.later'
  DESTINATION_REMINDER_QUEUE = 'amqp.bookings.reminder.now'
  DESTINATION_BOOKING_QUEUE = 'amqp.bookings.after'

  def initialize
    @connection = Bunny.new
    @connection.start
    @exchange = channel.default_exchange
  end

  def connection
    @connection
  end

  def publish(data)
    exchange.publish(data, routing_key: queue.name)
    channel.close
  end

  def publish_delayed(data)
    booking = JSON.parse(data)
    queue_name = "#{DELAYED_REMINDER_QUEUE}.#{booking['id']}"
    expires_time = get_expires_time(booking["start_date"])

    delayed_queue(queue_name, expires_time)
    exchange.publish(data, routing_key: queue_name)
    channel.close
  end

  # delete queue name if booking change available to conflict
  def delete_delayed_queue(booking_id)
    queue_name =  "#{DELAYED_REMINDER_QUEUE}.#{booking_id}"
    if connection.queue_exists?(queue_name)
      channel.queue_delete(queue_name)
    end
  end

  private

  def get_expires_time(start_date)

    reminder_before_minutes = ENV['REMINDER_BEFORE_MINUTES'].to_i
    start_date = start_date.to_time - reminder_before_minutes.minutes

    (((start_date - Time.now) / 1.minutes).ceil) * 1000 * 60
  end

  def channel
    @channel = connection.create_channel
  end

  def exchange
    @exchange
  end

  def queue
    @queue ||= channel.queue(DESTINATION_BOOKING_QUEUE, :durable => true)
  end

  def delayed_queue(queue_name, expires_time)

    # declare a queue with the DELAYED_REMINDER_QUEUE name
    channel.queue(queue_name, arguments: {
      # set the dead-letter exchange to the default queue
      'x-dead-letter-exchange' => '',
      # when the message expires, set change the routing key into the destination queue name
      'x-dead-letter-routing-key' => DESTINATION_REMINDER_QUEUE,
      # the time in milliseconds to keep the message in the queue
      'x-message-ttl' => expires_time
    }, auto_delete: true )
  end
end
