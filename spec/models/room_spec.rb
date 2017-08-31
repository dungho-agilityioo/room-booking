# == Schema Information
#
# Table name: rooms
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  schedule   :text
#  capacity   :integer
#

require 'rails_helper'

RSpec.describe Room, type: :model do
  describe "validations", :validations do
		it { is_expected.to validate_presence_of(:name) }
  end
end
