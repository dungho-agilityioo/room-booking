class ReminderEmail
  include Sidekiq::Worker
  def perform
    time_now = Time.now.in_time_zone('Asia/Saigon')
    time = (time_now + 10.minute ).strftime('%Y-%m-%d %H:%M')

    return if time_now.sunday? || time_now.saturday? || time_now.hour < 7 || time_now.hour > 18

    ReminderService.send_mail(time)
  end
end
