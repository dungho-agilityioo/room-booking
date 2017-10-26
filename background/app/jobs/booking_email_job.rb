require File.join(File.dirname(__FILE__), "../../config/require_all.rb")

class BookingEmailJob
  include Sneakers::Worker
  from_queue ENV['DESTINATION_BOOKING_QUEUE']

  def work(booking)
    puts "Sending email on Sneakers..."
    booking_params = JSON.parse(booking)
    MailerService.room_booking(booking_params)
    ack!
  end
end
