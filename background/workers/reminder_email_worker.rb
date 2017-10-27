require 'sneakers'
require 'json'
require File.join(File.dirname(__FILE__), "../lib/mailer_service.rb")
require File.join(File.dirname(__FILE__), "../lib/schedule_service.rb")

class ReminderEmailWorker
  include Sneakers::Worker
  from_queue ENV['EMAIL_REMINDER_10_MINTUTES_DESTINATION_QUEUE']

  def work(params)
    booking = JSON.parse(params)
    MailerService.reminder(booking)
    ScheduleService.new.add_messagge_reminder_next_booking(booking["id"]) if booking["daily"] == true
    ack!
  end
end
