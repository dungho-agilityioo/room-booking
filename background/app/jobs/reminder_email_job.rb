
require File.join(File.dirname(__FILE__), "../../config/require_all.rb")

class ReminderEmailJob
  include Sneakers::Worker
  from_queue "amqp.bookings.reminder.now"

  def work(booking)
    puts "Sending reminder email on Sneakers..."
    booking_params = JSON.parse(booking)
    MailerService.reminder(booking_params)
    ack!
  end
end

