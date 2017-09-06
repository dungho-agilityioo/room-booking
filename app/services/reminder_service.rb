class ReminderService
  class << self
    def send_mail(time)
      room_bookings = ActsAsBookable::Booking
          .includes(:booker, :bookable)
          .where("to_char(time_start, 'YYYY-MM-DD HH:MI') = ?", time)

      if room_bookings.present?
        room_bookings.each do |booking|
          UserMailer.reminder(booking).deliver_now
        end
      end
    end
  end
end
