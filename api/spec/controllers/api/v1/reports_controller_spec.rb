require 'rails_helper'

RSpec.describe Api::V1::ReportsController, type: :controller do
  before(:all) do
    room =  create(:room)
    @room2 = create(:room)
    @user =  create(:user, role: :admin)

    15.times do |t|
      room = @room2 if t == 14
      create(
          :booking_all,
          room: room,
          start_date: Date.today.next_week + t.hours,
          end_date: Date.today.next_week + t.hours + 30.minutes
        )
    end
  end

  before(:each) { request.headers["Authorization"] = token_generator(@user.id) }

  describe 'GET /index' do
    context 'when the request valid' do

      before {
        get :index, params: {
          start_date: Date.today.next_week + 3.hours,
          end_date: Date.today.next_week + 7.hours
        }
      }
      it { should respond_with(200) }
      specify { expect(json.size).to eq(4) }
    end

    context 'when room_id is present' do
      before {
        get :index, params: {
          room_id: @room2.id,
          start_date: Date.today.next_week + 3.hours,
          end_date: Date.today.next_week + 18.hours
        }
      }

      it { should respond_with(200) }
      specify { expect(json.size).to eq(1) }
    end

    context 'when the request invalid' do
      before { get :index, params: { filter: 'booked' } }

      it { should respond_with(400) }

      specify { expect(response.body).to match(/Parameter start_date is required/) }
    end
  end


end
