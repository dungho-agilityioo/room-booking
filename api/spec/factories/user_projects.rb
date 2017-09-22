# == Schema Information
#
# Table name: user_projects
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  project_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :user_project do
    user { create(:user) }
    project { create(:project) }
  end
end
