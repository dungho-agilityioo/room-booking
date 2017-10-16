require File.join(File.dirname(__FILE__), "../../config/require_all.rb")

class UserMailer < ApplicationMailer

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
