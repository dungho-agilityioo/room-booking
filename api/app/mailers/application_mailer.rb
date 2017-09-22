class ApplicationMailer < ActionMailer::Base
  default from: "Room Booking <#{ENV['ADMIN_EMAIL']}>"
  # layout 'mailer'
end
