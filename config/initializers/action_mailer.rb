if Rails.env.test?
  ActionMailer::Base.perform_deliveries = false
else
  ActionMailer::Base.perform_deliveries = true
end
ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => "gmail.com",
  :user_name            => ENV['SMTP_EMAIL'],
  :password             => ENV['SMTP_PASSWORD'],
  :authentication       => 'plain',
  :enable_starttls_auto => true,
  :openssl_verify_mode  => 'none'
}
ActionMailer::Base.default_url_options = {
  host: ENV["SMTP_HOST"]
}
