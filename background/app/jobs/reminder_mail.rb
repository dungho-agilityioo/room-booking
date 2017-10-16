
require File.join(File.dirname(__FILE__), "../../config/require_all.rb")

class ReminderMail
  include Sidekiq::Worker
  def perform
    # get list booked before 10 minutes
    minutes = 10
    room_bookings = BookingService.new.get_reminder_booked(minutes)
    if room_bookings.present?
      room_bookings["data"].each do |booking|
        UserMailer.reminder(booking, minutes).deliver
      end
    end
  end
end
