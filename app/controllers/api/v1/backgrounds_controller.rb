class Api::V1::BackgroundsController < ApplicationController
  skip_before_action :authenticate_request
  before_action :auth_token

  # GET /backgrounds
  # Get all booking before 10 minutes to get started
  def index
    time = (Time.now + 10.minute ).strftime('%Y-%m-%d %H:%M')

    bookings = ReminderService.booked_remider(time)
    respone_collection_serializer( bookings, 1, 1000 )
  end

  # POST /backgrounds/push
  def send_email
    message = JSON.parse request.body.read

    unless message.nil?
      attributes = message["message"]["attributes"]

      UserMailer.room_booking(attributes).deliver_now
    end

    json_response( {sucessed: true} )
  end

  private

    def auth_token
      return json_response({ message: Message.invalid_token }, 401) if params[:token] != ENV['PUBSUB_VERIFICATION_TOKEN']
    end

end
