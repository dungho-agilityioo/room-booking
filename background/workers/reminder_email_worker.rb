
require File.join(File.dirname(__FILE__), "../lib/mailer_service.rb")
require 'sneakers'

class ReminderEmailWorker
  include Sneakers::Worker
  from_queue ENV['EMAIL_REMINDER_10_MINTUTES_DESTINATION_QUEUE']

  def work(booking)
    puts "Sending reminder email on Sneakers..."
    booking_params = JSON.parse(booking)
    MailerService.reminder(booking_params)
    ack!
  end
end
