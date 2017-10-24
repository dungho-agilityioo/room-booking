require File.join(File.dirname(__FILE__), "../../config/require_all.rb")

class UserMailer < ApplicationMailer

  def room_booking(object)
    @user_name = object["user"]["name"]
    @room_name = object["room"]["name"]
    @title = object["title"]
    @state = object["state"]
    @start_date = object["start_date"].to_datetime.strftime('%m-%d-%Y %H-%M')
    @end_date = object["end_date"].to_datetime.strftime('%m-%d-%Y %H-%M')
    @daily = object["daily"]

    mail to: ENV['ADMIN_EMAIL'], subject: "[Room Booking] Submit Room Booking"
  end

  def reminder(object = {}, minutes)
    @title = object["title"]
    @room_name = object["room"]["name"]
    @description = object["description"]
    @start_date =object["start_date"].to_datetime.strftime('%m-%d-%Y %H-%M')
    @end_date = object["end_date"].to_datetime.strftime('%m-%d-%Y %H-%M')
    user_email = object["user"]["email"]

    mail to: "#{user_email}", subject: "[Room Booking] Reminder - #{@title} will start in #{minutes} minutes"
  end

end
