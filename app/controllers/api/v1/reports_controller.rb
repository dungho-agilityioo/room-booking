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
        limit_value = room_bookings.limit_value

        render json: {
          data:
            ActiveModel::Serializer::CollectionSerializer.new(
              room_bookings, each_serializer: ActsAsBookable::BookingSerializer
            ).as_json,
          metadata: {
            page: page,
            per_page: limit_value,
            total: total,
            total_page: (total.to_f / limit_value).ceil
          }}, status: 200
      end
    end
  end
end
