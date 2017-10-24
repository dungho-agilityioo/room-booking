require File.join(File.dirname(__FILE__), "../../config/require_all.rb")

class MailerService

  class << self
    def room_booking(object)
      start_date = object["start_date"]
      end_date = object["end_date"]

      content = "
        <p>#{object["user"]["name"] } makes request to booked room with the info below:</p>
        <p> - Room: #{object["room"]["name"]}</p>
        <p> - Title: #{object["title"]}</p>
        <p> - State: #{object["state"]}</p>
        <p> - Description: #{object["description"]}</p>
        <p> - Start date: #{start_date}</p>
        <p> - End date: #{end_date}</p>
      "

      subject = "[Room Booking] Submit Room Booking"

      send_message(ENV['ADMIN_EMAIL'], subject, content)
    end

    def reminder(object = {}, minutes)
      title = object["title"]
      start_date =object["start_date"]
      end_date = object["end_date"]

      content = "
        <p>#{title} will start in 10 minutes:</p>
        <p> - State: #{object["state"]}</p>
        <p> - Room: #{object["room"]["name"]}</p>
        <p> - Description: #{object["description"]}</p>
        <p> - Start date: #{start_date}</p>
        <p> - End date: #{end_date}</p>
      "

      user_email = object["user"]["email"]

      subject = "[Room Booking] Reminder - #{title} will start in #{minutes} minutes"

      send_message(user_email, subject, content)
    end

    private

    def send_message(to, subject, content)
      # First, instantiate the Mailgun Client with your API key
      mg_client = Mailgun::Client.new ENV['MAILGUN_API_KEY']

      # Define your message parameters
      message_params =  {
                          from: ENV['BOOKING_EMAIL'] || ENV['ADMIN_EMAIL'],
                          to:   to,
                          subject: subject,
                          html: content
                        }

      # Send your message through the client
      mg_client.send_message ENV['MAILGUN_DOMAIN'], message_params
    end
  end
end
