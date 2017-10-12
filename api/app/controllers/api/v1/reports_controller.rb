module Api
  module V1
    class ReportsController < ApplicationController
      swagger_controller :room, "Room Management"

      # GET reports?
      # :nocov:
      swagger_api :index do
        summary "Fetches all Rooms Booking in the range time"
        param :query, :page, :integer, :optional, "Page Number"
        param :query, :room_id, :integer, :optional, "Room Id"
        param :query, :time_start, :DateTime, :required, "Time Start"
        param :query, :time_end, :DateTime, :required, "Time End"
        response :ok, "Success", :Room
        response :unauthorized
      end
      # :nocov:
      def index
        authorize self

        param! :page, Integer
        param! :room_id, Integer, required: false
        param! :time_start, DateTime, required: true
        param! :time_end, DateTime, required: true
        page = params[:page].present? && params[:page] || 1

        total = ReportService.by_range_date(params).count

        room_bookings = ReportService.by_range_date(params).page(page)

        respone_collection_serializer(room_bookings, page, total)
      end

    end
  end
end
