require 'rails_helper'

RSpec.describe RoomBookingService do
  let!(:user) { create(:user) }
  let!(:room) { create(:room) }

  let(:booking) do
    ActsAsBookable::Booking.new(
      amount: 1,
      booker: user,
      bookable: room,
      time_start: Date.today.next_week + 9.hours,
      time_end: Date.today.next_week + 10.hours
    )
  end

  context '#daily is true' do
    before(:each) do
      booking.daily = true
      booking.save

      # RoomBookingService.new(@booking, 7).call
    end

    it 'generate next schedule' do
      expect(ActsAsBookable::Booking.count).to eq(7)
    end
  end

  context '#daily is false' do
    before(:each) do
      booking.daily = false
      booking.save

      # RoomBookingService.new(@booking, 7).call
    end

    it 'do not generate next schedule' do
      expect(ActsAsBookable::Booking.count).to eq(1)
    end
  end
end
