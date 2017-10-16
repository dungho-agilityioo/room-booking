require 'rails_helper'

RSpec.describe ReminderService do
  let!(:user) { create(:user) }

  describe '#send mail' do
    before do
      Timecop.travel(Date.today.next_week + 1.hours)
      now = Time.zone.now
      start_date = now + 1.minute
      create(:booking_with_user, user: user, start_date: start_date, end_date: now + 1.hours)
      # 10 minutes ago
      Timecop.travel(start_date - 10.minute )
      @booked = described_class.booked_remider( (Time.now + 10.minutes).strftime('%Y-%m-%d %H:%M'))
    end

    it 'return a booked' do
      expect(@booked).not_to be_empty
      expect(@booked.size).to eq(1)
    end
  end
end
