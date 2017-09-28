require 'rails_helper'

RSpec.describe UserMailer do
  let(:user) { create(:user) }
  let(:room_booing) {  create(:booked_with_user, booker: user) }

  describe '#send email' do
    let(:mail) { described_class.room_booking(
      { user_name: room_booing.booker&.name,
        room_name: room_booing.bookable&.name,
        title: room_booing.title,
        start_date: room_booing.time_start,
        end_date: room_booing.time_end,
        daily: room_booing.daily
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
        .to match(/- Title: #{room_booing.title}/)
    end

    it 'assign the room name' do
      expect(mail.body)
        .to match(/- Room: #{room_booing.bookable.name}/)
    end

    it 'assign the start date' do
      expect(mail.body)
        .to match(/- Start date: #{room_booing.time_start.strftime('%m-%d-%Y %H-%M')}/)
    end

    it 'assign the end date' do
      expect(mail.body)
        .to match(/- End date: #{room_booing.time_end.strftime('%m-%d-%Y %H-%M')}/)
    end
  end

end
