
ActsAsBookable::Booking.class_eval do
  validate :limit_time
  validates_datetime :time_end, :after => :time_start
  validates_datetime :time_start, :on => :create, :on_or_after => lambda { Time.now + 7.hours }

  ##
  # Retrieves overlapped bookings, given a bookable and some booking options
  #
  scope :overlapped, ->(bookable,opts) {
    query = where(bookable_id: bookable.id)

    # Time options
    if(opts[:time].present?)
      query = ActsAsBookable::DBUtils.time_comparison(query,'time','=',opts[:time])
    end
    if(opts[:time_start].present?)
      query = ActsAsBookable::DBUtils.time_comparison(query,'time_end', '>', opts[:time_start])
    end
    if(opts[:time_end].present?)
      query = ActsAsBookable::DBUtils.time_comparison(query,'time_start', '<', opts[:time_end])
    end
    query
  }

  private

  def limit_time
    time_start_limit = DateTime.new(self.time_start.year, self.time_start.month, self.time_start.day, 7, 30)
    time_end_limit = DateTime.new(self.time_end.year, self.time_end.month, self.time_end.day, 17, 30)

    if self.time_start < time_start_limit || self.time_end > time_end_limit
      raise (
        ActsAsBookable::AvailabilityError.new(
          ActsAsBookable::T.er(
            '.availability.unavailable_interval',
            model: 'Room',
            time_start: Time.zone.parse(self.time_start.to_s).utc,
            time_end: Time.zone.parse(self.time_end.to_s).utc
          )
        )
      )
    end
  end
end
