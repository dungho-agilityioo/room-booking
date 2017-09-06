class UserMailer < ApplicationMailer

  def room_booking(opts = {})
    user = opts[:params].booker
    room = opts[:params].bookable
    @user_name = user.name
    @room_name = room.name
    @title = opts[:params][:title]
    @start_date = opts[:params][:time_start]
    @end_date = opts[:params][:time_end]
    @daily = opts[:params][:daily]

    mail to: ENV['ADMIN_EMAIL'], subject: "[Room Booking] Submit Room Booking"
  end

  def reminder(object)
    @title = object.title
    @room_name = object.bookable.try(:name)
    @description = object.description
    @start_date = object.time_start
    @end_date = object.time_end

    mail to: "#{object.booker.try(:email)}", subject: "[Room Booking] Reminder - #{object.title} will start in 10 minutes"
  end

end
