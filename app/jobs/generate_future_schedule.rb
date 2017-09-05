class GenerateFutureSchedule
  include Sidekiq::Worker
  def perform
    room_bookings = ActsAsBookable::Booking.where(daily: true).all

    room_bookings.each do |booking|
      RoomBookingService.new(booking, 7).call
    end
  end
end
