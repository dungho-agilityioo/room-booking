class ReminderService
  class << self
    def send_mail(time)
      room_bookings = booked_remider(time)

      if room_bookings.present?
        room_bookings.each do |booking|
          UserMailer.reminder(booking).deliver_now
        end
      end
    end

    def booked_remider(time)
      ActsAsBookable::Booking
          .includes(:booker, :bookable)
          .where("to_char(time_start, 'YYYY-MM-DD HH:MI') = ?", time)
    end
  end
end
