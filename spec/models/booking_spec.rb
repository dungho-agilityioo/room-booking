# == Schema Information
#
# Table name: bookings
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  project_id   :integer
#  booking_type :integer
#  reason       :text
#  start_date   :date
#  start_hour   :time
#  end_date     :date
#  end_hour     :time
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

RSpec.describe Booking, type: :model do
  describe "validations", :validations do
    it { is_expected.to validate_presence_of(:user_id) }
    it { is_expected.to validate_presence_of(:booking_type) }
    it { is_expected.to validate_presence_of(:reason) }
    it { is_expected.to validate_presence_of(:start_date) }
    it { is_expected.to validate_presence_of(:start_hour) }
    it { is_expected.to validate_presence_of(:end_date) }
    it { is_expected.to validate_presence_of(:end_hour) }
    it { is_expected.to belong_to(:user)}
  end
end
