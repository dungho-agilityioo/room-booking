if Rails.env.test?
  ActionMailer::Base.perform_deliveries = false
  ActionMailer::Base.delivery_method = :test
else
  ActionMailer::Base.perform_deliveries = true
  ActionMailer::Base.delivery_method = :mailgun
end

ActionMailer::Base.mailgun_settings = {
  api_key: ENV['MAILGUN_API_KEY'],
  domain: ENV['MAILGUN_DOMAIN'],
}
