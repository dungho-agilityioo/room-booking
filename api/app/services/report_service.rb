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

      ActsAsBookable::Booking
        .includes(:bookable, :booker)
        .where( :time_start => time_start..time_end)
        .or(
            ActsAsBookable::Booking
              .includes(:bookable, :booker)
              .where( :time_end => time_start..time_end)
          )
        .order(:time_start, :bookable_id)

    end
  end
end
