class UserMailer < ApplicationMailer

  def room_booking(opts = {})
    user = opts[:params].booker
    room = opts[:params].bookable
    @user_name = user.name
    @room_name = room.name
    @title = opts[:params][:title]
    @start_date = opts[:params][:time_start]
    @end_date = opts[:params][:time_end]
    mail to: ENV['ADMIN_EMAIL'], from: "#{user.email}", subject: "[Room Booking] Submit Room Booking"
  end

end
