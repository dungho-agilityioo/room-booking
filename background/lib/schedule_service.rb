require 'dotenv/load'
require 'httparty'

class ScheduleService
  include HTTParty
  base_uri ENV['API_BASE_URL']

  def add_messagge_create_next_booking(data)
    self.class.post("/bookings", body: data, headers: headers )
  end

  def add_messagge_reminder_next_booking(id)
    self.class.get("/bookings/#{id}", headers: headers )
    true
  end

  private

  def headers
    { "API_KEY" => ENV['AUTHORIZATION_APIKEY'] }
  end
end
