# schedule_file = "config/schedule.yml"

Sidekiq.configure_server do |config|
  redis_host = ENV.fetch('REDIS_HOST','localhost')
  config.redis = { url: "redis://"+redis_host+":6379/0" }

  schedule_file = File.expand_path("../../../config/scheduler.yml",__FILE__)

  if File.exists?(schedule_file) && Sidekiq.server?
    Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
  end
end

Sidekiq.configure_client do |config|
  redis_host = ENV.fetch('REDIS_HOST','localhost')
  config.redis = { url: "redis://"+redis_host+":6379/0" }
end
