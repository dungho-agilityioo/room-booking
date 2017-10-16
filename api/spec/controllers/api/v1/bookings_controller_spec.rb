require 'rails_helper'

RSpec.describe Api::V1::BookingsController, type: :controller do

  let!(:user) { create(:user) }
  let!(:room) { create(:room) }
  let!(:booking) { create(:booking, room: room, user: user ) }
  let(:booking_id) { booking.id }

  # authorize request
  let(:headers) { valid_headers }


  before(:each) { request.headers["Authorization"] = headers["Authorization"] }

  describe 'GET /books' do
    before(:each) { get :index }

    it { should respond_with(200) }

    it 'returns list Bookings' do
      expect(json).not_to be_empty
      expect(json.size).to eq(1)
    end
  end

  describe 'GET /books/:id' do
    before { get :show, params: { id: booking_id } }

    context 'when the record exists' do
      it { should respond_with(200) }

      it 'return the record' do
        expect(json['id'].to_i).to eq(booking_id)
      end
    end

    context 'when the record do not exists' do
      let(:booking_id) { 1000 }

      it { should respond_with(404) }

      it 'return a not found message' do
        expect(response.body).to match(/Couldn't find /)
      end
    end

  end

  describe 'POST /books' do
    let(:valid_attributes) do
      FactoryGirl.attributes_for(:booking)
        .merge( start_date: Date.today.next_week + 1.day + 8.hours )
        .merge( end_date: Date.today.next_week + 1.day + 10.hours )
        .merge( room_id: room.id )
    end

    context 'when the request is valid' do

      before { post :create, params: valid_attributes }

      it { should respond_with(201) }

      it 'should be reserve the room' do
        expect(json["start_date"].to_datetime).to eq( Date.today.next_week + 1.day + 8.hours )
        expect(json["end_date"].to_datetime).to eq( Date.today.next_week + 1.day + 10.hours )
      end
      specify { expect(json['user']['id'].to_i).to eq(user.id) }

    end

    context 'when the room is overlaps' do
      before do
        user2 = create(:user)
        request.headers["Authorization"] = token_generator(user2.id)
        params = FactoryGirl.attributes_for(:booking).merge(room_id: room.id)
        post :create, params: params
      end

      it { should respond_with(201) }
      it 'should be state is conflict' do
        expect(json['state']).to eq('conflict')
      end
    end

    context 'when the room is overlaps in the same user' do
      before { post :create, params: FactoryGirl.attributes_for(:booking).merge(room_id: room.id) }

      it { should respond_with(422) }
      specify { expect(response.body).to match(/Booking is overlapping/) }
    end

    context 'when the request is missing the title' do
      before { post :create, params: { room_id: room.id } }

      it { should respond_with(400) }
      specify { expect(response.body).to match(/Parameter title is required/) }
    end

    context 'when the request is missing the room' do
      before { post :create, params: FactoryGirl.attributes_for(:booking) }

      it { should respond_with(404) }
      specify { expect(response.body).to match(/Couldn't find Room/) }
    end

    context 'when the request is missing the start date' do
      before do
        post :create,
              params: FactoryGirl.attributes_for(:booking)
                        .merge(room_id: room.id)
                        .except(:start_date)
      end

      it { should respond_with(400) }
      specify { expect(response.body).to match(/Parameter start_date is required/) }
    end

    context 'when the request is missing the end date' do
      before do
        post :create,
              params: FactoryGirl.attributes_for(:booking)
                        .merge(room_id: room.id)
                        .except(:end_date)
      end

      it { should respond_with(400) }
      specify { expect(response.body).to match(/Parameter end_date is required/) }
    end

  end

  describe 'DELETE /books/:id' do

    context 'when Booking is exists' do
      before { delete :destroy, params: { id: booking_id } }

      it { should respond_with(204) }
    end

    context 'when Booking do not exists' do
      before { delete :destroy, params: { id: 1000 } }

      specify { expect(response.body).to match(/Couldn't find Booking/) }
    end
  end

end