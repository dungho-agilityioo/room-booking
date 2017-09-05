class ReportService

  class << self
    def by_range_date(params)
      ActsAsBookable::Booking
        .includes(:bookable, :booker)
        .where(bookable_id: params[:room_id])
        .where("time_start >= ?", params[:time_start].to_datetime)
        .where("time_end <= ?", params[:time_end].to_datetime)
    end

    def by_project(project_id)
      ActsAsBookable::Booking
        .includes(:bookable, :booker)
        .where(project_id: project_id)
    end

    def get_booked(time_start, time_end)
      time_start = Time.zone.now if time_start.nil? || time_start < Time.zone.now

      room_bookings = ActsAsBookable::Booking
        .includes(:bookable, :booker)
        .where("time_start >= ?", time_start.to_datetime)

      room_bookings = room_bookings.where("time_end <= ?", time_end.to_datetime) if time_end.present?

      room_bookings
    end
  end
end
