require 'rails_helper'

RSpec.describe UserMailer do
  let(:user) { create(:user) }
  let(:booking) {  create(:booking_with_user, user: user) }

  describe '#send email' do
    let(:mail) { described_class.room_booking(
      { user_name: booking.user&.name,
        room_name: booking.room&.name,
        title: booking.title,
        start_date: booking.start_date,
        end_date: booking.end_date,
        daily: booking.daily
      }.as_json).deliver_now }

    it 'renders the subject' do
      expect(mail.subject).to match(/\[Room Booking\] Submit Room Booking/)
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([ENV['ADMIN_EMAIL']])
    end

    it 'renders the user name' do
      expect(mail.body)
        .to match(/#{user.name} makes request to booked room with the info below:/)
    end

    it 'assign the title' do
      expect(mail.body)
        .to match(/- Title: #{booking.title}/)
    end

    it 'assign the room name' do
      expect(mail.body)
        .to match(/- Room: #{booking.room.name}/)
    end

    it 'assign the start date' do
      expect(mail.body)
        .to match(/- Start date: #{booking.start_date.strftime('%m-%d-%Y %H-%M')}/)
    end

    it 'assign the end date' do
      expect(mail.body)
        .to match(/- End date: #{booking.end_date.strftime('%m-%d-%Y %H-%M')}/)
    end
  end

end
