class ReminderService
  class << self

    def booked_remider(time)
      Booking
          .includes(:booker, :bookable)
          .where("to_char(start_date, 'YYYY-MM-DD HH:MI') = ?", time)
    end
  end
end
