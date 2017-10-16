class BookingService
  class << self

    def get_availables(start_date, end_date)
      available_slots = []

      booked = ReportService.get_booked(start_date, end_date)

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


    # private

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
