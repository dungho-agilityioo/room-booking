class BooksSearchService
  class << self

    def check_availability(time_start, time_end)
      availables = []
      time_start = Time.zone.now if time_start < Time.zone.now

      return availables if time_end < time_start

      booked = ReportService.get_booked(time_start, time_end)

      rooms = Room.all
      time_search = [ time_start, time_end ]

      rooms.each do |room|
        books = booked.select {|b| b.bookable_id == room.id }
        room_name = room.name

        if books.present?
          get_available(books, availables, time_search, room_name )
        else
          availables << { room: room_name, time_start: time_start, time_end: time_end }
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

        exists = booked_dates.any? { |h| (h["time_start"]..h["time_end"]).overlaps?((d[:time_start] + 1.second )..d[:time_end]) }

        availables << { room: room_name, time_start: d[:time_start], time_end: d[:time_end] } unless exists

      end
    end

    # Input: [Tue, 12 Sep 2017 01:00:00 UTC +00:00, Tue, 12 Sep 2017 03:00:00 UTC +00:00, Tue, 12 Sep 2017 06:00:00 UTC +00:00, Tue, 12 Sep 2017 07:00:00 UTC +00:00]
    # Output: [
    #   {time_start: Tue, 12 Sep 2017 01:00:00 UTC +00:00, time_end: Tue, 12 Sep 2017 03:00:00 UTC +00:00}
    #   {time_start: Tue, 12 Sep 2017 03:00:00 UTC +00:00, time_end: Tue, 12 Sep 2017 06:00:00 UTC +00:00}
    #   {time_start: Tue, 12 Sep 2017 06:00:00 UTC +00:00, time_end: Tue, 12 Sep 2017 07:00:00 UTC +00:00}
    # ]
    def split_date(dates)
      rs = []
      dates.each_cons(2) do |ele, next_ele|
        rs << { time_start: ele, time_end: next_ele }
      end

      rs
    end

    def merge_date(books)
      time_start = books.pluck(:time_start).map(&:to_datetime)
      time_end = books.pluck(:time_end).map(&:to_datetime)

      time_start + time_end
    end

    def flatter_date(books)
      books.as_json.map { |b| b.slice("time_start", "time_end") }
    end
  end
end
