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
#

class User < ApplicationRecord

  attr_accessor :login
  attr_accessor :skip_password_validation

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :trackable,
          :recoverable, :rememberable, :validatable,
          :omniauthable, omniauth_providers: [:google_oauth2],
          authentication_keys: [:login]

  validates :name, :provider, :uid, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }

  def login=(login)
    @login = login
  end

  def login
    @login || self.email
  end


  def self.from_omniauth(auth)
    user = User.find_or_initialize_by(
        provider: auth[:provider],
        uid: auth[:uid],
        email: auth[:info][:email] ) do |u|
      u[:name] = auth[:info][:name]
      u[:first_name] = auth[:info][:first_name]
      u[:last_name] = auth[:info][:last_name]
    end
    user.skip_password_validation = true
    user.save
    user
  end

  protected

  def password_required?
    return false if skip_password_validation
    super
  end

end
