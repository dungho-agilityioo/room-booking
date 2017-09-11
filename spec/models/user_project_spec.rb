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

require 'rails_helper'

RSpec.describe UserProject, type: :model do
  describe '#validations', :validations do
    it { is_expected.to validate_presence_of(:user_id) }
    it { is_expected.to validate_presence_of(:project_id) }
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:project) }
  end
end
