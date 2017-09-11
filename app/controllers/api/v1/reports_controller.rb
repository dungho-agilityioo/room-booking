module Api
  module V1
    class ReportsController < ApplicationController
      swagger_controller :room, "Room Management"

      # POST reports/range_date
      # :nocov:
      swagger_api :by_range_date do |api|
        summary "Fetches all Rooms Booking in the range time"
        param :query, :page, :integer, :optional, "Page Number"
        Api::V1::ReportsController::add_common_params(api)
        response :ok, "Success", :Room
        response :unauthorized
      end
      # :nocov:
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

      # POST reports/by_project
      # :nocov:
      swagger_api :by_project do |api|
        summary "Fetches all Rooms Booking by project id"
        param :query, :page, :integer, :optional, "Page Number"
        param :form, :project_id, :integer, :required, "Project Id"
        response :ok, "Success", :Room
        response :unauthorized
      end
      # :nocov:
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
