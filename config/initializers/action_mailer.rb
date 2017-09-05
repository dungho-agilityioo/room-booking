if Rails.env.development?
  ActionMailer::Base.raise_delivery_errors = true
  ActionMailer::Base.perform_deliveries = true
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
    host: 'localhost:3000'
  }
end
