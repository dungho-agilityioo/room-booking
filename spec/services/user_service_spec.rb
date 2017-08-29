require 'rails_helper'

RSpec.describe UserService do
  context '#Create' do
    let(:user) { UserService.create_admin }

    it 'user is admin' do
      expect(user.admin?).to be true
    end

    it 'email is valid' do
      expect(user.email).to eq(ENV["ADMIN_EMAIL"])
    end
  end
end
