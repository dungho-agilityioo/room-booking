require 'rails_helper'

describe Api::V1::Admin::ReportsControllerPolicy do
  subject { described_class.new(user, self) }

  context 'User admin is granted permission' do
    let(:user) { create(:user, role: :admin) }

    it { is_expected.to permit_action(:index) }
  end

  context 'The staff is do not granted permission' do
    let(:user) { create(:user) }

    it { is_expected.to_not permit_action(:index) }
  end

end
