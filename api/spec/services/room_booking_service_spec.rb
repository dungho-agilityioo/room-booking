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

  describe '#gen_next_schedule' do

    context '#daily is true' do
      before(:each) do
        booking.daily = true
        booking.save
      end

      it 'generate next schedule' do
        expect(ActsAsBookable::Booking.count).to eq(7)
      end
    end

    context '#daily is false' do
      before(:each) do
        booking.daily = false
        booking.save
      end

      it 'do not generate next schedule' do
        expect(ActsAsBookable::Booking.count).to eq(1)
      end
    end
  end

  describe '#remove_future_schedule' do
    before do
      booking.daily = true
      booking.save
    end

    it 'delete all room booking' do
      expect(ActsAsBookable::Booking.count).to eq(7)
      booking.destroy
      expect(ActsAsBookable::Booking.count).to eq(0)
    end
  end

end
