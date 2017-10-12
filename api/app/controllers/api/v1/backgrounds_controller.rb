class Api::V1::BackgroundsController < ApplicationController
  skip_before_action :authenticate_request
  before_action :auth_token

  # GET /backgrounds
  # Get all booking before 10 minutes to get started
  def index
    time = (Time.now + 10.minute ).strftime('%Y-%m-%d %H:%M')

    bookings = ReminderService.booked_remider(time)
    render json: {
        data:
          ActiveModel::Serializer::CollectionSerializer.new(
            bookings, each_serializer: BookingSerializer
          ).as_json
        }
  end

  # POST /backgrounds/push
  def send_email
    message = nil
    body = request.body.read
    logger.info "Body >> #{body}"
    message = JSON.parse body unless body.blank?

    unless message.nil?
      attributes = message["message"]["attributes"]

      UserMailer.room_booking(attributes).deliver_now
    end

    json_response( {sucessed: true} )
  end

  private

    def auth_token
      token = params[:token] || request.headers["Authorization"]
      return json_response({ message: Message.invalid_token }, 401) if token != ENV['PUBSUB_VERIFICATION_TOKEN'] && token != ENV['AUTHORIZATION_APIKEY']
    end

end
