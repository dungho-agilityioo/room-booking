# unless Rails.env.test?

#   begin
#     $rabbitmq_connection = Bunny.new
#     $rabbitmq_connection.start
#   rescue Bunny::TCPConnectionFailed => e
#     puts "@@Error connecting: #{e.inspect}"
#     retry
#   end

#   $rabbitmq_channel = $rabbitmq_connection.create_channel
# end
