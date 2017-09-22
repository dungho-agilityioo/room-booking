require File.join(File.dirname(__FILE__), "../../config/require_all.rb")

class BookingService
  include HTTParty
  base_uri ENV['BASE_API_PATH']

  def get_reminder_books
    self.class.get("/reminders", headers: headers)
  end

  private
    def headers
      { "Authorization" => ENV['AUTHORIZATION_APIKEY'] }
    end
end
