class Api::V1::RemindersController < ApplicationController

  # GET /reminders
  # Get all booking before 10 minutes to get started
  def index
    time = (Time.now + 10.minute ).strftime('%Y-%m-%d %H:%M')

    bookings = ReminderService.booked_remider(time)
    respone_collection_serializer( bookings, 1, 1000 )
  end

end
