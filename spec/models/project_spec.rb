# == Schema Information
#
# Table name: projects
#
#  id         :integer          not null, primary key
#  name       :string
#  status     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Project, type: :model do
  describe "validations", :validations do
    it { is_expected.to validate_presence_of(:name) }

    it {
      is_expected.to define_enum_for(:status)
        .with([:active, :inactive])
    }

  end
end
