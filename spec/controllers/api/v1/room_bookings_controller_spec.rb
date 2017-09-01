require 'rails_helper'

RSpec.describe Api::V1::RoomBookingsController, type: :controller do

  let!(:user) { create(:user) }
  let!(:room) { create(:room) }
  let!(:room_booking) { create(:room_booking, bookable: room, booker: user ) }
  let(:room_booking_id) { room_booking.id }

  # authorize request
  let(:headers) { valid_headers }


  before(:each) { request.headers["Authorization"] = headers["Authorization"] }

  describe 'GET /room_bookings' do
    before(:each) { get :index }

    it { should respond_with(200) }

    it 'returns list room bookings' do
      expect(json).not_to be_empty
      expect(json.size).to eq(1)
    end
  end

  describe 'GET /room_bookings/:id' do
    before { get :show, params: { id: room_booking_id } }

    context 'when the record exists' do
      it { should respond_with(200) }

      it 'return the record' do
        expect(json['id'].to_i).to eq(room_booking_id)
      end
    end

    # context 'when the record do not exists' do
    #   let(:room_booking_id) { 1000 }

    #   it { should respond_with(404) }

    #   it 'return a not found message' do
    #     expect(response.body).to match(/Couldn't find /)
    #   end
    # end

  end


  describe 'DELETE /room_bookings/:id' do
    before { delete :destroy, params: { id: room_booking_id } }

    it { should respond_with(204) }
  end
end
