require 'rails_helper'

describe ProjectPolicy do
  subject { ProjectPolicy.new(user, project) }

  context 'User admin is granted permission' do
    let(:user) { create(:user, role: :admin) }
    let(:project) { create(:project) }

    it { is_expected.to permit_action(:index) }
    it { is_expected.to permit_action(:new) }
    it { is_expected.to permit_action(:create) }
    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:edit) }
    it { is_expected.to permit_action(:update) }
    it { is_expected.to permit_action(:destroy) }
  end

  context 'The staff is do not granted permission' do
    let(:user) { create(:user) }
    let(:project) { create(:project) }

    it { is_expected.to_not permit_action(:new) }
    it { is_expected.to_not permit_action(:create) }
    it { is_expected.to_not permit_action(:edit) }
    it { is_expected.to_not permit_action(:update) }
    it { is_expected.to_not permit_action(:destroy) }
  end
end
