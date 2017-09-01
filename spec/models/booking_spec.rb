
require 'rails_helper'

RSpec.describe ActsAsBookable::Booking, type: :model do
  describe "validations", :validations do
    let(:user) { create(:user) }
    let(:room) { create(:room) }

    it { is_expected.to callback(:reset_time_end).before(:create) }

    context '#date is invalid' do

      before(:each) do
        @booking = ActsAsBookable::Booking.new(amount: 2)
        @booking.booker = user
        @booking.bookable = room
        @booking.time_start = Date.today.prev_week + 9.hours
        @booking.time_end = Date.today.prev_week
      end

      it 'start date in the past' do
        @booking.valid?
        expect(@booking.errors.full_messages.at(1)).to match(/Time start must be on or after/)
      end

      it 'end date is less than start date' do
        @booking.valid?
        expect(@booking.errors.full_messages.at(0)).to match(/Time end must be after/)
      end
    end

    context '#the start date is out of range' do
      before(:each) do
        @booking = ActsAsBookable::Booking.new(amount: 2)
        @booking.booker = user
        @booking.bookable = room
        @booking.time_start = Date.today.next_week + 1.hours
        @booking.time_end = Date.today.next_week + 2.hours
      end

      it 'get a message not available error' do
        expect { @booking.valid? }
            .to raise_error(ActsAsBookable::AvailabilityError, /the Room is not available from #{@booking.time_start.to_s} to #{@booking.time_end.to_s}/)
      end
    end

    context '#the end date is out of range' do
      before(:each) do
        @booking = ActsAsBookable::Booking.new(amount: 2)
        @booking.booker = user
        @booking.bookable = room
        @booking.time_start = Date.today.next_week + 16.hours
        @booking.time_end = Date.today.next_week + 19.hours
      end

      it 'get a message not available error' do
        byebug
        expect { @booking.valid? }
            .to raise_error(ActsAsBookable::AvailabilityError, /the Room is not available from #{@booking.time_start.to_s} to #{@booking.time_end.to_s}/)
      end
    end

  end
end
