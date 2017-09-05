class ReportService

  class << self
    def by_range_date(params)
      ActsAsBookable::Booking
        .where(bookable_id: params[:room_id])
        .where("time_start >= ?", params[:time_start].to_datetime)
        .where("time_end <= ?", params[:time_end].to_datetime)
    end

    def by_project(project_id)
      ActsAsBookable::Booking
        .where(project_id: project_id)
    end
  end
end
