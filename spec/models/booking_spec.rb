
require 'rails_helper'

RSpec.describe ActsAsBookable::Booking, type: :model do
  describe "validations", :validations do
    let(:user) { create(:user) }
    let(:room) { create(:room) }

    it { is_expected.to callback(:reset_time_end).before(:create) }
    it { is_expected.to callback(:gen_next_schedule).after(:create).if(:daily?) }
    it { is_expected.to callback(:remove_future_schedule).after(:destroy).if(:daily?) }

  end
end
