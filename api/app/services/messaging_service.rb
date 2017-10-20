class MessagingService
  include Singleton

  def initialize
    @queue = $rabbitmq_channel.queue('email_queue')
    @exchange = $rabbitmq_channel.default_exchange
  end

  def publish(data)
    @exchange.publish(data, :routing_key => @queue.name)
  end

  def receive
    begin
      @queue.subscribe do |delivery_info, metadata, payload|
        puts "Sending email..."
        UserMailer.room_booking(payload).deliver_later
      end
    rescue Interrupt => _
      $rabbitmq_connection.close
    end
  end

end
