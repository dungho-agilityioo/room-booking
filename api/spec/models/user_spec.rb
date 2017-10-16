# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  name                   :string
#  first_name             :string
#  last_name              :string
#  provider               :string           default(""), not null
#  uid                    :string           default(""), not null
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string
#  locked_at              :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  role                   :integer
#

require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations", :validations do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:provider) }
    it { is_expected.to validate_presence_of(:uid) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to callback(:set_default_role).after(:initialize).if(:new_record?) }
    subject { build(:user) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { is_expected.to have_many(:bookings)}


  end

  describe ".Sign In" do
    let(:auth) {
      {
        provider: "gitlab",
        uid: Faker::Number.number(10),
        info: {
          email: Faker::Internet.email,
          name: Faker::Name.name,
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name
        },
        credentials: {
          token: Faker::Config.random.seed,
          refresh_token: Faker::Config.random.seed,
          expires_at: DateTime.now
        }
      }
    }

    context 'create a user' do
      let(:user)  { User.from_omniauth(auth) }

      it 'should be provider is valid' do
        expect(user.provider).to eq("gitlab")
      end

      it 'should be role is staff' do
        expect( user.staff? ).to be true
      end
    end
  end
end
