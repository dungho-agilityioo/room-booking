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
      .where('start_date > ?', Time.zone.now)
      .order(:start_date)
  end

  def gen_next_schedule
    nex_schedule = get_next_schedule
    next_number = @gen_number - nex_schedule.count

    if next_number > 0
      next_occurrences = @room_booking
                            .bookable
                            .schedule
                            .next_occurrences(next_number, nex_schedule.first.start_date.to_time)
      next_occurrences.each do |occurrence|
        @user.book! @room,
            title: @room_booking.title,
            start_date: start_date(occurrence),
            end_date: end_date(occurrence),
            description: @room_booking.description,
            amount: 1,
            booking_ref_id: @room_booking.id
      end
    end
  end

  def start_date(occurrence)
    booking_start_date = @room_booking.start_date.to_datetime
    DateTime.new(occurrence.year, occurrence.month, occurrence.day, booking_start_date.hour, booking_start_date.minute)
  end

  def end_date(occurrence)
    booking_end_date = @room_booking.end_date.to_datetime
    DateTime.new(occurrence.year, occurrence.month, occurrence.day, booking_end_date.hour, booking_end_date.minute)
  end

  def remove_future_schedule
    Booking
      .where(booking_ref_id: @room_booking.id)
      .where('start_date > ?', Time.zone.now)
      .delete_all
  end
end
