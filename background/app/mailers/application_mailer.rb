require File.join(File.dirname(__FILE__), "../../config/require_all.rb")

class ApplicationMailer < ActionMailer::Base
  default from: "Room Booking <#{ENV['ADMIN_EMAIL']}>"
  # layout 'mailer'
end
