require File.join(File.dirname(__FILE__), "../../config/require_all.rb")

class UserMailer < ApplicationMailer

  def room_booking(object = {})
    @user_name = object["user_name"]
    @room_name = object["room_name"]
    @title = object["title"]
    @start_date = object["start_date"].to_datetime.strftime('%m-%d-%Y %H-%M')
    @end_date = object["end_date"].to_datetime.strftime('%m-%d-%Y %H-%M')
    @daily = object["daily"]

    mail to: ENV['ADMIN_EMAIL'], subject: "[Room Booking] Submit Room Booking" do |format|
      format.html
    end
  end

  def reminder(object = {})
    @title = object["title"]
    @room_name = object["room"]["name"]
    @description = object["description"]
    @start_date =object["time_start"].to_datetime.strftime('%m-%d-%Y %H-%M')
    @end_date = object["time_end"].to_datetime.strftime('%m-%d-%Y %H-%M')
    user_email = object["user"]["email"]

    mail to: "#{user_email}", subject: "[Room Booking] Reminder - #{@title} will start in 10 minutes"
  end

end
