class ReportService

  class << self
    def range_date(params)
      bookings = Booking
        .includes(:bookable, :booker)
        .where("start_date >= ?", params[:start_date].to_datetime)
        .where("end_date <= ?", params[:end_date].to_datetime)

      bookings = bookings.where(bookable_id: params[:room_id]) if params[:room_id].present?

      bookings
    end

    def get_booked(start_date, end_date)
      Booking
        .includes(:bookable, :booker)
        .where( :start_date => start_date..end_date)
        .or(
            Booking
              .includes(:bookable, :booker)
              .where( :end_date => start_date..end_date)
          )
        .order(:start_date, :bookable_id)
    end
  end
end
