class BooksSearchService
  class << self

    def check_availability(time_start, time_end)
      availables = []
      time_start = Time.zone.now if time_start < Time.zone.now

      return availables if time_end < time_start

      booked = ReportService.get_booked(time_start, time_end)

      rooms = Room.all
      get_available(booked, availables, time_end )
      rooms.each do |room|
        books = booked.select {|b| b.bookable_id == room.id }

        if books.present?
          get_available(books, availables, time_end )
        else
          availables << { time_start: time_start, time_end: time_end, room: room.name }
        end
      end

      availables
    end

    private

    def get_available(books, availables, time_end)
      time_start = Time.zone.now
      room_name = nil
      books.each do |b|
        if b.time_start - time_start > 0
          room_name = b.bookable.name
          availables << { time_start: time_start, time_end: b.time_start, room: room_name }
          time_start = b.time_end
        end
      end

      availables << { time_start: time_start, time_end: time_end, room: room_name } if time_start < time_end
    end
  end
end
