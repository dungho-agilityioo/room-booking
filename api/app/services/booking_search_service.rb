class BookingSearchService
  class << self

    def check_availability(start_date, end_date)
      availables = []
      start_date = Time.zone.now if start_date < Time.zone.now

      return availables if end_date < start_date

      booked = ReportService.get_booked(start_date, end_date)

      rooms = Room.all
      time_search = [ start_date, end_date ]

      rooms.each do |room|
        books = booked.select {|b| b.bookable_id == room.id }
        room_name = room.name

        if books.present?
          get_available(books, availables, time_search, room_name )
        else
          availables << { room: room_name, start_date: start_date, end_date: end_date }
        end
      end
      availables
    end

    # private

    def get_available(books, availables, time_search, room_name)

      range_date  = (merge_date(books) + time_search).uniq.sort
      dates = split_date(range_date)
      booked_dates = flatter_date(books)

      dates.each do |d|

        exists = booked_dates.any? { |h| (h["start_date"]..h["end_date"]).overlaps?((d[:start_date] + 1.second )..d[:end_date]) }

        availables << { room: room_name, start_date: d[:start_date], end_date: d[:end_date] } unless exists

      end
    end

    # Input: [Tue, 12 Sep 2017 01:00:00 UTC +00:00, Tue, 12 Sep 2017 03:00:00 UTC +00:00, Tue, 12 Sep 2017 06:00:00 UTC +00:00, Tue, 12 Sep 2017 07:00:00 UTC +00:00]
    # Output: [
    #   {start_date: Tue, 12 Sep 2017 01:00:00 UTC +00:00, end_date: Tue, 12 Sep 2017 03:00:00 UTC +00:00}
    #   {start_date: Tue, 12 Sep 2017 03:00:00 UTC +00:00, end_date: Tue, 12 Sep 2017 06:00:00 UTC +00:00}
    #   {start_date: Tue, 12 Sep 2017 06:00:00 UTC +00:00, end_date: Tue, 12 Sep 2017 07:00:00 UTC +00:00}
    # ]
    def split_date(dates)
      rs = []
      dates.each_cons(2) do |ele, next_ele|
        rs << { start_date: ele, end_date: next_ele }
      end

      rs
    end

    def merge_date(books)
      start_date = books.pluck(:start_date).map(&:to_datetime)
      end_date = books.pluck(:end_date).map(&:to_datetime)

      start_date + end_date
    end

    def flatter_date(books)
      books.as_json.map { |b| b.slice("start_date", "end_date") }
    end
  end
end
