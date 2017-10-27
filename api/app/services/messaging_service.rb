class MessagingService

  def initialize(channel_name)
    @connection = Bunny.new
    @connection.start
    @channel = @connection.create_channel(channel_name)
    @exchange = @channel.direct('bookings')
  end

  def publish(data)
    exchange.publish(data, routing_key: queue.name)
    connection.close
  end

  def publish_delayed(data)
    booking = JSON.parse(data)
    delayed_queue_name = "#{ENV['EMAIL_REMINDER_10_MINTUTES_DELAYED_QUEUE']}.#{booking['id']}"

    expires_time = get_expires_time(booking["start_date"])

    delayed_queue(delayed_queue_name, ENV['EMAIL_REMINDER_10_MINTUTES_DESTINATION_QUEUE'], expires_time)

    exchange.publish(data, routing_key: delayed_queue_name)
    connection.close
  end

  def publish_delayed_for_next_schedule(booking_id)

    data = { id: booking_id }.to_json

    # should next 7 days
    expires_time = ((((Time.now + 7.days).beginning_of_day - Time.now) / 1.minutes).ceil) * 1000 * 60

    delayed_queue_name = "#{ENV['NEXT_BOOKING_CREATE_DELAYED_QUEUE']}.#{booking_id}"

    delayed_queue(delayed_queue_name, ENV['NEXT_BOOKING_CREATE_DESTINATION_QUEUE'], expires_time)

    exchange.publish(data, routing_key: delayed_queue_name)

    connection.close
  end

  # delete queue name if booking change available to conflict
  def delete_delayed_queue(booking_id)
    queue_name =  "#{ENV['EMAIL_REMINDER_10_MINTUTES_DELAYED_QUEUE']}.#{booking_id}"

    if connection.queue_exists?(queue_name)
      channel.queue_delete(queue_name)
    end
  end

  private

  def connection
    @connection
  end

  def get_expires_time(start_date)

    reminder_before_minutes = ENV['REMINDER_BEFORE_MINUTES'].to_i
    start_date = start_date.to_time - reminder_before_minutes.minutes

    (((start_date - Time.now) / 1.minutes).ceil) * 1000 * 60
  end

  def channel
    @channel
  end

  def exchange
    @exchange
  end

  def queue
    email_after_booking_queue = ENV['EMAIL_AFTER_BOOKING_DESTINATION_QUEUE']
    @queue ||= channel.queue(email_after_booking_queue, :durable => true)
                      .bind(exchange, routing_key: email_after_booking_queue)
  end

  def delayed_queue(delayed_queue_name, distination_queue, expires_time)

    # declare a queue with the EMAIL_REMINDER_10_MINTUTES_DELAYED_QUEUE name
    channel.queue(delayed_queue_name, arguments: {
      # set the dead-letter exchange to the default queue
      'x-dead-letter-exchange' => '',
      # when the message expires, set change the routing key into the destination queue name
      'x-dead-letter-routing-key' => distination_queue,
      # the time in milliseconds to keep the message in the queue
      'x-message-ttl' => expires_time
    }, auto_delete: true )
    .bind(exchange, routing_key: delayed_queue_name)
  end
end
