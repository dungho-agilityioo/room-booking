class RoomBookingService
  prepend SimpleCommand

  def initialize(room_booking, gen_number = 0)
    @room_booking = room_booking
    @gen_number = gen_number
    @user = room_booking.booker
    @room = room_booking.bookable
  end

  # Service entry point
  def call
    if @gen_number != 0
      gen_next_schedule
    else
      remove_future_schedule
    end
  end

  private

  def get_next_schedule
    Booking
      .where(bookable: @room)
      .where(booker: @user)
      .where('time_start > ?', Time.zone.now)
      .order(:time_start)
  end

  def gen_next_schedule
    nex_schedule = get_next_schedule
    next_number = @gen_number - nex_schedule.count

    if next_number > 0
      next_occurrences = @room_booking
                            .bookable
                            .schedule
                            .next_occurrences(next_number, nex_schedule.first.time_start.to_time)
      next_occurrences.each do |occurrence|
        @user.book! @room,
            title: @room_booking.title,
            time_start: time_start(occurrence),
            time_end: time_end(occurrence),
            description: @room_booking.description,
            amount: 1,
            generate_for_id: @room_booking.id
      end
    end
  end

  def time_start(occurrence)
    booking_time_start = @room_booking.time_start.to_datetime
    DateTime.new(occurrence.year, occurrence.month, occurrence.day, booking_time_start.hour, booking_time_start.minute)
  end

  def time_end(occurrence)
    booking_time_end = @room_booking.time_end.to_datetime
    DateTime.new(occurrence.year, occurrence.month, occurrence.day, booking_time_end.hour, booking_time_end.minute)
  end

  def remove_future_schedule
    Booking
      .where(generate_for_id: @room_booking.id)
      .where('time_start > ?', Time.zone.now)
      .delete_all
  end
end
