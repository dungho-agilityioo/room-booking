# schedule_file = "config/schedule.yml"
require 'sidekiq'
require 'sidekiq-cron'
require 'dotenv/load'

Sidekiq.configure_server do |config|
  redis_url = ENV.fetch('REDIS_URL','redis://redis:6379/0')
  config.redis = { url: redis_url }
  schedule_file = File.join(File.dirname(__FILE__), "scheduler.yml")

  if File.exists?(schedule_file) && Sidekiq.server?
    Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
  end
end

Sidekiq.configure_client do |config|
  redis_url = ENV.fetch('REDIS_URL','redis://redis:6379/0')
  config.redis = { url: redis_url }
end
