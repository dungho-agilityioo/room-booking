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

    context 'when the record do not exists' do
      let(:room_booking_id) { 1000 }

      it { should respond_with(404) }

      it 'return a not found message' do
        expect(response.body).to match(/Couldn't find /)
      end
    end

  end

  describe 'POST /room_bookings' do
    let(:valid_attributes) do
      FactoryGirl.attributes_for(:room_booking)
        .merge( time_start: Date.today.next_week + 1.day + 8.hours )
        .merge( time_end: Date.today.next_week + 1.day + 10.hours )
        .merge( room_id: room.id )
    end

    context 'when the request is valid' do

      before { post :create, params: valid_attributes }

      it { should respond_with(201) }

      it 'should be reserve the room' do
        expect(json["attributes"]["time-start"].to_datetime).to eq( Date.today.next_week + 1.day + 8.hours )
        expect(json["attributes"]["time-end"].to_datetime).to eq( Date.today.next_week + 1.day + 10.hours - 1.second )
      end

      it 'should be booker is user' do
        expect(json['relationships']['booker']['data']['id'].to_i).to eq(user.id)
      end

      it 'should be bookable is room' do
        expect(json['relationships']['bookable']['data']['id'].to_i).to eq(room.id)
      end
    end

    context 'when the request is missing the title' do
      before { post :create, params: { } }

      it { should respond_with(400) }

      it 'return a validation failure message' do
        expect(response.body).to match(/Parameter title is required/)
      end
    end

    context 'when the request is missing the room' do
      before { post :create, params: FactoryGirl.attributes_for(:room_booking) }

      it { should respond_with(400) }

      it 'return a validation failure message' do
        expect(response.body).to match(/Parameter room_id is required/)
      end
    end

    context 'when the request is missing the start date' do
      before do
        post :create,
              params: FactoryGirl.attributes_for(:room_booking)
                        .merge(room_id: room.id)
                        .except(:time_start)
      end

      it { should respond_with(400) }

      it 'return a validation failure message' do
        expect(response.body).to match(/Parameter time_start is required/)
      end
    end

    context 'when the request is missing the end date' do
      before do
        post :create,
              params: FactoryGirl.attributes_for(:room_booking)
                        .merge(room_id: room.id)
                        .except(:time_end)
      end

      it { should respond_with(400) }

      it 'return a validation failure message' do
        expect(response.body).to match(/Parameter time_end is required/)
      end
    end

  end

  describe 'DELETE /room_bookings/:id' do

    context 'when room booking is exists' do
      before { delete :destroy, params: { id: room_booking_id } }

      it { should respond_with(204) }
    end

    context 'when room booking do not exists' do
      before { delete :destroy, params: { id: 1000 } }

      it 'return a not found message' do
        expect(response.body).to match(/Couldn't find Room Booking/)
      end
    end
  end
end
