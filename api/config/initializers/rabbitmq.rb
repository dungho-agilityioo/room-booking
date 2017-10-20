$rabbitmq_connection = Bunny.new
$rabbitmq_connection.start

$rabbitmq_channel = $rabbitmq_connection.create_channel
MessagingService.instance.receive
