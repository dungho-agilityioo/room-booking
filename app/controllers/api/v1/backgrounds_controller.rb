class Api::V1::BackgroundsController < ApplicationController
  skip_before_action :authenticate_request

  # GET /backgrounds
  # Get all booking before 10 minutes to get started
  def index
    time = (Time.now + 10.minute ).strftime('%Y-%m-%d %H:%M')

    bookings = ReminderService.booked_remider(time)
    respone_collection_serializer( bookings, 1, 1000 )
  end

  # GET /backgrounds/pull
  def send_email
    messages = PubsubService.new.pull_books_messages
    puts "@12 #{messages.inspect}"
    messages.each do |msg|
      UserMailer.room_booking(msg.attributes).deliver_now
      msg.acknowledge!
    end

    json_response( {sucessed: true})
  end

end
