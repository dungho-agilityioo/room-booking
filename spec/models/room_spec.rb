require 'rails_helper'

RSpec.describe Room, type: :model do
  describe Room do
  	context 'validations' do
  		it { is_expected.to validate_presence_of(:name) }
  	end
  end
end
