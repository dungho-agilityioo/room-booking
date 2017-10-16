require 'rails_helper'

describe RoomPolicy do
  subject { RoomPolicy.new(user, room) }

  context 'The user is admin will be permit' do
    let(:user) { create(:user, role: :admin) }
    let(:room) { create(:room) }

    it { is_expected.to permit_action(:index) }
    it { is_expected.to permit_action(:new) }
    it { is_expected.to permit_action(:create) }
    it { is_expected.to permit_action(:edit) }
    it { is_expected.to permit_action(:update) }
    it { is_expected.to permit_action(:destroy) }
  end

  context 'The user is staff will be forbid' do
    let(:user) { create(:user) }
    let(:room) { create(:room) }

    it { is_expected.to forbid_action(:new) }
    it { is_expected.to forbid_action(:create) }
    it { is_expected.to forbid_action(:edit) }
    it { is_expected.to forbid_action(:update) }
    it { is_expected.to forbid_action(:destroy) }
  end
end
