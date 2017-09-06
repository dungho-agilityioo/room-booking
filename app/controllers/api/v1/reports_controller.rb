module Api
  module V1
    class ReportsController < ApplicationController

      def by_range_date
        authorize self

        param! :page, Integer
        param! :room_id, Integer, required: true
        param! :time_start, DateTime, required: true
        param! :time_end, DateTime, required: true

        page = params[:page].present? && params[:page] || 1
        total = ReportService.by_range_date(params).count

        room_bookings = ReportService.by_range_date(params).page(page)

        respone_collection_serializer(room_bookings, page, total)
      end

      def by_project
        authorize self

        param! :page, Integer
        param! :project_id, Integer, required: true

        page = params[:page].present? && params[:page] || 1
        total = ReportService.by_project(params[:project_id]).count

        room_bookings = ReportService.by_project(params[:project_id]).page(page)

        respone_collection_serializer(room_bookings, page, total)
      end

    end
  end
end
