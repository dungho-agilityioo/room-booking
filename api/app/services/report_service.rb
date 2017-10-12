class ReportService

  class << self
    def by_range_date(params)
      bookings = Booking
        .includes(:bookable, :booker)
        .where("time_start >= ?", params[:time_start].to_datetime)
        .where("time_end <= ?", params[:time_end].to_datetime)

      bookings = bookings.where(bookable_id: params[:room_id]) if params[:room_id].present?

      bookings
    end

    def get_booked(time_start, time_end)
      Booking
        .includes(:bookable, :booker)
        .where( :time_start => time_start..time_end)
        .or(
            Booking
              .includes(:bookable, :booker)
              .where( :time_end => time_start..time_end)
          )
        .order(:time_start, :bookable_id)
    end
  end
end
