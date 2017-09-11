require 'rails_helper'

describe Api::V1::ReportsControllerPolicy do
  subject { Api::V1::ReportsControllerPolicy.new(user, self) }

  context 'User admin is granted permission' do
    let(:user) { create(:user, role: :admin) }

    it { is_expected.to permit_action(:by_range_date) }
    it { is_expected.to permit_action(:by_project) }
  end

  context 'The staff is do not granted permission' do
    let(:user) { create(:user) }

    it { is_expected.to_not permit_action(:by_range_date) }
    it { is_expected.to_not permit_action(:by_project) }
  end

end