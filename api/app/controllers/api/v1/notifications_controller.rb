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

  # POST /notifications/push
  def send_email
    message = nil
    body = request.body.read
    message = JSON.parse body unless body.blank?

    unless message.nil?
      attributes = message["message"]["attributes"]

      UserMailer.room_booking(attributes).deliver_now
    end

    json_response( {succeed: true} )
  end

  private

    def auth_token
      token = params[:token] || request.headers["Authorization"]
      return json_response({ message: I18n.t('errors.messages.invalid_token') }, 401) if token != ENV['PUBSUB_VERIFICATION_TOKEN'] && token != ENV['AUTHORIZATION_APIKEY']
    end

end
