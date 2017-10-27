require 'sneakers'
require 'json'
require File.join(File.dirname(__FILE__), "../lib/mailer_service.rb")
require File.join(File.dirname(__FILE__), "../lib/schedule_service.rb")

class GenerateNextScheduleWorker
  include Sneakers::Worker
  from_queue ENV['NEXT_BOOKING_CREATE_DESTINATION_QUEUE']

  def work(booking)
    puts "Create Next Schedule Booking..."
    params = JSON.parse(booking)
    ScheduleService.new.add_messagge_create_next_booking(params)
    ack!
  end
end
