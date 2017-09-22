
require File.join(File.dirname(__FILE__), "../../config/require_all.rb")

class ReminderMail
  include Sidekiq::Worker
  def perform
    room_bookings = BookingService.new.get_reminder_books
    if room_bookings.present?
      room_bookings["data"].each do |booking|
        UserMailer.reminder(booking).deliver
      end
    end
  end
end
