class Api::V1::NotificationsController < ApplicationController
  skip_before_action :authenticate_request
  before_action :auth_token

  # GET /notifications?time=<time>
  # Get all booking before <time> to get started
  def index
    param! :time, DateTime, required: true
    time = params[:time].to_datetime.strftime('%Y-%m-%d %H:%M')

    bookings = ReminderService.booked_remider(time)
    render json: {
        data:
          ActiveModel::Serializer::CollectionSerializer.new(
            bookings, each_serializer: BookingSerializer
          ).as_json
        }
  end

  private

    def auth_token
      token = params[:token] || request.headers["Authorization"]
      return json_response({ message: I18n.t('errors.messages.invalid_token') }, 401) if token != ENV['AUTHORIZATION_APIKEY']
    end

end
