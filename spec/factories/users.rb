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

FactoryGirl.define do
	factory :user do
		provider { "gitlab" }
    uid { Time.now.to_i }
    email { Faker::Internet.email }
    name { Faker::Name.name }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    password { Faker::Number.number(10) }
	end

  factory :user_admin, class: User, parent: :user do
    role { :admin }
  end
end
