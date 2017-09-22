class UserMailer < ApplicationMailer

  def room_booking(object = {})
    @user_name = object["user_name"]
    @room_name = object["room_name"]
    @title = object["title"]
    @start_date = object["start_date"].to_datetime.strftime('%m-%d-%Y %H-%M')
    @end_date = object["end_date"].to_datetime.strftime('%m-%d-%Y %H-%M')
    @daily = object["daily"]

    mail to: ENV['ADMIN_EMAIL'], subject: "[Room Booking] Submit Room Booking"
  end

end
