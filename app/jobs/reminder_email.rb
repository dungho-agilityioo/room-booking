class ReminderEmail
  include Sidekiq::Worker
  def perform
    time = (Time.now + 10.minute ).strftime('%Y-%m-%d %H:%M')

    ReminderService.send_mail(time)
  end
end
