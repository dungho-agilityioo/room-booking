
require 'rails_helper'

RSpec.describe Booking, type: :model do
  describe "validations", :validations do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:room_id) }
    it { is_expected.to validate_presence_of(:user_id) }
    it { is_expected.to validate_presence_of(:start_date) }
    it { is_expected.to validate_presence_of(:end_date) }

    it { is_expected.to callback(:check_duplicate).before(:save) }
    it { is_expected.to callback(:set_state).before(:create) }

    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:room) }
  end

  describe '#remove' do
    context '.booking is daily' do
      let(:booking) { create(:booking_all, daily: true) }
      before { booking.remove }

      specify { expect(booking.state).to eq("closed") }

      it 'should remove dalay create next booking queue' do
        queue_name = "#{ENV['NEXT_BOOKING_CREATE_DELAYED_QUEUE']}.#{booking.id}"
        expect(MessagingService.new(300).connection.queue_exists?(queue_name)).to be_falsey
      end

      it 'should remove all the next booking' do
        expect(Booking.active.count).to eq(0)
      end
    end

    context '.booking once' do
      let!(:booking) { create(:booking_all) }
      before { booking.remove }

      specify { expect(booking.state).to eq("closed") }

      it 'should remove delay reminder queue' do
        queue_name =  "#{ENV['EMAIL_REMINDER_10_MINTUTES_DELAYED_QUEUE']}.#{booking.id}"
        expect(MessagingService.new(200).connection.queue_exists?(queue_name)).to be_falsey
      end

    end
  end

  describe '#activate' do
    before(:all) do
      room = create(:room)
      @booking = create(:booking_with_room, room: room)
      @booking1 = create(:booking_with_room, room: room)
    end

    context 'before activate' do
      specify { expect(@booking.state).to eq('available') }
      specify { expect(@booking1.state).to eq('conflict') }
    end

    context 'after activate' do

      before(:all) { @booking1.activate }
      it 'should be change state booking1 to available' do
        expect(@booking1.state).to eq("available")
      end

      it 'should be change state booking to conflict' do
        @booking.reload
        expect(@booking.state).to eq("conflict")
      end

    end
  end

  describe '#reopen' do
    let!(:booking) { create(:booking_all, daily: true) }
    before do
      t = Time.local(2017, 10, 25, 07, 30, 0)
      Timecop.travel(t)
      booking.remove
    end
    context 'before reopen' do
      specify { expect(booking.state).to eq('closed') }
    end
    context 'after reopen' do
      before { booking.reopen }

      specify { expect(booking.state).to eq('available') }
      it 'should generate next booking' do
        count = Booking.where(booking_ref_id: booking.id)
                    .or(Booking.where(id: booking.id))
                    .count
        expect(count).to eq(7)
      end
    end

    after do
      Timecop.return
    end
  end
end
