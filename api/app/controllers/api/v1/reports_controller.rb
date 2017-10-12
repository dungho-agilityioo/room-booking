module Api
  module V1
    class ReportsController < ApplicationController
      swagger_controller :room, "Room Management"

      # GET reports?
      # :nocov:
      swagger_api :index do |api|
        summary "Fetches all Rooms Booking in the range time"
        param :query, :page, :integer, :optional, "Page Number"
        param_list :query, :type, :string, :required, "Type", [:date, :project]
        api.param :query, :room_id, :integer, :optional, "Room Id"
        api.param :query, :project_id, :integer, :optional, "Project Id"
        api.param :query, :time_start, :DateTime, :optional, "Time Start"
        api.param :query, :time_end, :DateTime, :optional, "Time End"
        response :ok, "Success", :Room
        response :unauthorized
      end
      # :nocov:
      def index
        authorize self

        param! :type, String, required: true
        param! :page, Integer

        if params[:type] == 'date'
          param! :room_id, Integer, required: true
          param! :time_start, DateTime, required: true
          param! :time_end, DateTime, required: true
        else
          param! :project_id, Integer, required: true
        end
        page = params[:page].present? && params[:page] || 1

        if params[:type] == 'date'
          total = ReportService.by_range_date(params).count

          room_bookings = ReportService.by_range_date(params).page(page)
        else
          project_id = params[:project_id]

          total = ReportService.by_project(project_id).count

          room_bookings = ReportService.by_project(project_id).page(page)
        end

        respone_collection_serializer(room_bookings, page, total)
      end

    end
  end
end
