class BookingService
  class << self

    # get the rooms available by time range
    def get_availables(start_date, end_date)
      available_slots = []

      booked = get_booked(start_date, end_date)

      rooms = Room.all
      filter_time = [ start_date, end_date ]

      rooms.each do |room|
        room_booked = booked.select {|b| b.room_id == room.id }
        room_name = room.name

        if room_booked.present?
          room_available(booked, available_slots, filter_time, room_name )
        else
          available_slots << { room: room_name, start_date: start_date, end_date: end_date }
        end
      end

      available_slots
    end

    # get the rooms booked by time range
    def get_booked(start_date, end_date)
      Booking
        .includes(:room, :user)
        .where(state: :available)
        .where( :start_date => start_date..end_date)
        .or(
            Booking
              .includes(:room, :user)
              .where( :end_date => start_date..end_date)
          )
        .order(:start_date, :room_id)
    end

    # generate <days> days for the next booking
    def create_next_booking(booking, days)
      # it is 1 because it was just created
      total_pending_booking = total_future_booking(booking.id)
      total_pending_booking = total_pending_booking > 0 && total_pending_booking || 1
      # number days need booking before
      total_days = days - total_pending_booking

      if total_days > 0
        add_more_days = 0
        (1..total_days).each do |day|
          start_date = booking.start_date + day.days

          # will not create if on saturday or sunday
          if start_date.saturday? || start_date.sunday?
            add_more_days = add_more_days + 1
            next
          end

          create_booking_with_params(booking, day)
        end

        # If it meet on Saturday or Sunday, create more for missing
        if add_more_days > 0
          (1..add_more_days).each do |day|
            create_booking_with_params(booking, days + day)
          end
        end
      end
      # add delayed message for next day
      MessagingService.instance.publish_delayed_for_next_schedule(booking.id)
    end

    def remove_future_booking(booking)
       Booking
        .where(booking_ref_id: booking.id)
        .where('start_date > ?', Time.zone.now)
        .delete_all
    end

    private

    def create_booking_with_params(booking, day)
      booking_attrs = booking.attributes.except("id")
      start_date = booking.start_date + day.days
      end_date = booking.end_date + day.days
      begin
        Booking.without_callback(:create, :after, :send_email_booking) do
          Booking.without_callback(:create, :after, :generate_next_booking) do
            Booking.create(booking_attrs.merge(
                  "start_date" => start_date,
                  "end_date" => end_date,
                  "booking_ref_id" => booking.id
                ))
          end
        end
      rescue Exception => ex
        puts "Error generate next schedule: #{ex.message}"
      end
    end

    # get total of booking in the future
    def total_future_booking(booking_id)
      Booking
        .where('start_date > ?', Time.zone.now)
        .where(booking_ref_id: booking_id).count
    end

    def room_available(booked, available_slots, filter_time, room_name)

      range_date  = (pluck_date(booked) + filter_time).uniq.sort
      dates = split_date(range_date)
      booked_dates = booked.as_json.map { |b| b.slice("start_date", "end_date") }

      dates.each do |d|
        start_date = d[:start_date] + 1.second
        end_date = d[:end_date] - 1.second
        overlaps = booked_dates.any? { |booking| (booking["start_date"]..booking["end_date"]).overlaps?(start_date..end_date) }

        available_slots << { room: room_name, start_date: start_date, end_date: end_date } unless overlaps
      end
    end

    # Split one-dimensional array into two-dimensional array
    # Input: [Tue, 12 Sep 2017 01:00:00 UTC +00:00, Tue, 12 Sep 2017 03:00:00 UTC +00:00, Tue, 12 Sep 2017 06:00:00 UTC +00:00, Tue, 12 Sep 2017 07:00:00 UTC +00:00]
    # Output: [
    #   {start_date: Tue, 12 Sep 2017 01:00:00 UTC +00:00, end_date: Tue, 12 Sep 2017 03:00:00 UTC +00:00}
    #   {start_date: Tue, 12 Sep 2017 03:00:00 UTC +00:00, end_date: Tue, 12 Sep 2017 06:00:00 UTC +00:00}
    #   {start_date: Tue, 12 Sep 2017 06:00:00 UTC +00:00, end_date: Tue, 12 Sep 2017 07:00:00 UTC +00:00}
    # ]
    def split_date(dates)
      rs = []
      dates.each_cons(2) do |date, next_date|
        rs << { start_date: date, end_date: next_date}
      end
      rs
    end

    # pluck start and end date
    def pluck_date(booked)
      booked.pluck(:start_date).map(&:to_datetime) + booked.pluck(:end_date).map(&:to_datetime)
    end

  end
end
