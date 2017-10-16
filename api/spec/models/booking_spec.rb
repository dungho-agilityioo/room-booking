
require 'rails_helper'

RSpec.describe Booking, type: :model do
  describe "validations", :validations do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:room_id) }
    it { is_expected.to validate_presence_of(:user_id) }
    it { is_expected.to validate_presence_of(:start_date) }
    it { is_expected.to validate_presence_of(:end_date) }

    it { is_expected.to callback(:generate_next_schedule).after(:create).if(:daily?) }
    it { is_expected.to callback(:remove_future_schedule).after(:destroy).if(:daily?) }
    it { is_expected.to callback(:check_duplicate).before(:save) }
    it { is_expected.to callback(:set_state).before(:save) }

    it {
      is_expected.to define_enum_for(:state)
        .with([:available, :conflict])
    }

    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:room) }
  end
end
