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

class User < ApplicationRecord

  attr_accessor :skip_password_validation
  enum role: [:staff, :admin]

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :trackable, :omniauthable,
         omniauth_providers: [:google_oauth2]

  validates :name, :provider, :uid, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }

  after_initialize :set_default_role, :if => :new_record?
  acts_as_booker

  has_many :user_projects
  has_many :projects, through: :user_projects

  def set_default_role
    self.role ||= :staff
  end

  def self.from_omniauth(auth)
    UserService.create_user(auth)
  end

  protected

  def password_required?
    return false if skip_password_validation
    super
  end

end
