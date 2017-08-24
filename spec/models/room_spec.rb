# == Schema Information
#
# Table name: rooms
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Room, type: :model do
  describe Room do
  	context 'validations' do
  		it { is_expected.to validate_presence_of(:name) }
  	end
  end
end
