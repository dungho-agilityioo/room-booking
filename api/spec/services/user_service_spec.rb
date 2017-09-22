require 'rails_helper'

RSpec.describe UserService do
  context '#Create user' do
    let!(:time_now) { Time.now.to_i }
    let!(:user_valid) do
      {
        provider: 'gitlab',
        uid: time_now,
        info: {
          email: 'alexsanches@gmail.com',
          name: 'Alex Sanches',
          first_name: 'Alex',
          last_name: 'Sanches'
        }
      }
    end
    let!(:user) { create(:user, email: 'alexsanches@gmail.com') }

    it 'create a user' do
      expect(user.staff?).to be true
    end

    it 'update if exists' do
      user = UserService.create_user(user_valid)
      expect(user.uid.to_i).to eq(time_now)
    end
  end

  context '#Create admin' do
    let(:user) { UserService.create_admin }

    it 'user is admin' do
      expect(user.admin?).to be true
    end

    it 'email is valid' do
      expect(user.email).to eq(ENV["ADMIN_EMAIL"])
    end
  end
end
