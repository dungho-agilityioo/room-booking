class MessagingService
  include Singleton
  DELAYED_REMINDER_QUEUE = 'amqp.bookings.reminder.later'
  DESTINATION_REMINDER_QUEUE = 'amqp.bookings.reminder.now'
  DESTINATION_BOOKING_QUEUE = 'amqp.bookings.after'

  def initialize
    @connection ||= Bunny.new
    @connection.start
    @exchange = channel.default_exchange
  end

  def channel
    @channel ||= connection.create_channel
  end

  def connection
    @connection
  end

  def exchange
    @exchange
  end

  def queue
    @queue ||= channel.queue(DESTINATION_BOOKING_QUEUE, :durable => true)
  end

  def delayed_squeue(expires_time)

    # declare a queue with the DELAYED_REMINDER_QUEUE name
    channel.queue(DELAYED_REMINDER_QUEUE, arguments: {
      # set the dead-letter exchange to the default queue
      'x-dead-letter-exchange' => '',
      # when the message expires, set change the routing key into the destination queue name
      'x-dead-letter-routing-key' => DESTINATION_REMINDER_QUEUE,
      # the time in milliseconds to keep the message in the queue
      'x-message-ttl' => expires_time
    })
  end

  def publish(data)
    exchange.publish(data, routing_key: queue.name)
  end

  def publish_delayed(data)
    expires_time = get_expires_time(data)

    delayed_squeue(expires_time)
    exchange.publish(data, routing_key: DELAYED_REMINDER_QUEUE)
  end

  private

  def get_expires_time(data)
    booking = JSON.parse(data)
    start_date = booking["start_date"].to_time - 10.minutes

    (((start_date - Time.now) / 1.minutes).ceil) * 1000
  end
end
