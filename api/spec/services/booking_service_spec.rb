require 'rails_helper'

RSpec.describe BookingService do
  let(:booking) do
    attrs = FactoryGirl.attributes_for(:booking_all)
    Booking.new(
      attrs.except(:id, :room, :user)
        .merge(room_id: attrs[:room][:id], user_id: attrs[:user][:id])
    )
  end

  describe '#create_next_booking' do

    context '#daily is true' do
      before(:each) do
        booking.daily = true
        booking.save
      end

      it 'generate next schedule' do
        expect(Booking.count).to eq(7)
        Booking.first.destroy
      end
    end

  end

  describe '#remove_future_booking' do
    before do
      booking.daily = true
      booking.save
    end

    it 'delete all room booking' do
      expect(Booking.count).to eq(7)
      booking.remove
      expect(Booking.active.count).to eq(0)
    end
  end

end
