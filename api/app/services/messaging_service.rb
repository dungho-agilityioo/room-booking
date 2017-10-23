class MessagingService
  include Singleton

  def initialize
    @exchange = channel.default_exchange
  end

  def channel
    @connection ||= Bunny.new
    @connection.start
    @channel ||= @connection.create_channel
  end

  def queue
    @queue ||= channel.queue('email_queue')
  end

  def publish(data)
    @exchange.publish(data, :routing_key => queue.name)
    @connection.close
  end

  # def receive
  #   begin
  #     @queue.subscribe do |delivery_info, metadata, payload|
  #       puts "Sending email..."
  #       UserMailer.room_booking(payload).deliver_later
  #     end
  #   rescue Interrupt => _
  #     $rabbitmq_connection.close
  #   end
  # end

end
