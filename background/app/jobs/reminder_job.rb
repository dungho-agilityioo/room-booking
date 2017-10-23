require File.join(File.dirname(__FILE__), "../../config/require_all.rb")

class ReminderJob
  include Sneakers::Worker
  from_queue "email_queue", env: nil

  def work(raw_event)
    puts "Sending email on Sneakers..."
    # event_params = JSON.parse(raw_event)
    # SomeWiseService.build.call(event_params)
    # ack!
  end
end
