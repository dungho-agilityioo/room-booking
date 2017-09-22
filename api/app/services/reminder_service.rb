class ReminderService
  class << self

    def booked_remider(time)
      ActsAsBookable::Booking
          .includes(:booker, :bookable)
          .where("to_char(time_start, 'YYYY-MM-DD HH:MI') = ?", time)
    end
  end
end
