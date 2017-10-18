require 'rails_helper'

RSpec.describe Api::V1::BookingsController, type: :controller do

  let!(:user) { create(:user) }

  # authorize request
  let(:headers) { valid_headers }

  before(:each) { request.headers["Authorization"] = headers["Authorization"] }

  describe 'GET /bookings' do

    context '#getall' do
      let!(:room) { create(:room) }
      let!(:booking) { create(:booking, room: room, user: user ) }
      before(:each) { get :index }

      it { should respond_with(200) }

      it 'returns list Bookings' do
        expect(json).not_to be_empty
        expect(json.size).to eq(1)
      end
    end

    context '#filter' do
      before(:all) do
        room = create(:room)
        15.times do |t|
          create(
              :booking_all,
              room: room,
              start_date: Date.today.next_week + t.hours,
              end_date: Date.today.next_week + t.hours + 30.minutes
            )
        end
      end
      context '#booked' do

        context 'when the request valid' do

          before {
            get :index, params: {
              filter: 'booked',
              start_date: Date.today.next_week + 3.hours,
              end_date: Date.today.next_week + 7.hours
            }
          }
          it { should respond_with(200) }
          specify { expect(json.size).to eq(5) }

        end

        context 'when the request invalid' do
          before { get :index, params: { filter: 'booked' } }

          it { should respond_with(400) }

          specify { expect(response.body).to match(/Parameter start_date is required/) }
        end
      end


      context '#available' do
        context 'when the request valid' do
          before {
            get :index, params: {
              filter: 'available',
              start_date: Date.today.next_week + 3.hours,
              end_date: Date.today.next_week + 7.hours
            }
          }
          it { should respond_with(200) }
          specify { expect(json.size).to eq(4) }
        end

        context 'when the request invalid' do
          before { get :index, params: { filter: 'available' } }

          it { should respond_with(400) }

          specify { expect(response.body).to match(/Parameter start_date is required/) }
        end
      end
    end
  end


  describe 'GET /bookings/:id' do
    let!(:booking) { create(:booking_all) }

    context 'when the record exists' do
      before { get :show, params: { id: booking.id } }

      it { should respond_with(200) }

      it 'return the record' do
        expect(json['id'].to_i).to eq(booking.id)
      end
    end

    context 'when the record do not exists' do
      before { get :show, params: { id: 1000 } }

      it { should respond_with(404) }

      it 'return a not found message' do
        expect(response.body).to match(/Couldn't find /)
      end
    end

  end

  describe 'POST /bookings' do
    let!(:room) { create(:room) }
    let!(:booking) { create(:booking, room: room, user: user ) }
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

  describe 'PUT /bookings/:id' do
    let!(:room) { create(:room) }
    let!(:user2) { create(:user) }
    let!(:booking) { create(:booking, room: room, user: user ) }
    let!(:booking2) { create(:booking, room: room, user: user2 ) }
    let(:valid_attributes) { FactoryGirl.attributes_for(:booking).merge( room_id: room.id ) }

    context 'when the request is valid' do
      before {
        put :update, params: valid_attributes
                                  .merge(title: "Booking for scrum")
                                  .merge(id: booking.id)
      }

      it { should respond_with(200) }
      specify { expect(json["title"]).to eq('Booking for scrum') }
    end

    context 'update #state' do

      context 'should not update if user is staff' do
        before do
          request.headers["Authorization"] = token_generator(user2.id)
          put :update, params: valid_attributes.merge(state: :available).merge(id: booking2.id)
        end

        specify { expect(json['state']).to eq('conflict') }
      end

      context 'should update if user is admin' do
        before do
          user3 = create(:user_admin)
          request.headers["Authorization"] = token_generator(user3.id)
          put :update, params: valid_attributes.merge(state: :available).merge(id: booking2.id)
        end

        specify { expect(json['state']).to eq('available') }
      end
    end

  end

  describe 'DELETE /bookings/:id' do
    let!(:booking) { create(:booking_all) }
    context 'when Booking is exists' do
      before { delete :destroy, params: { id: booking.id } }

      it { should respond_with(204) }
    end

    context 'when Booking do not exists' do
      before { delete :destroy, params: { id: 1000 } }

      it { should respond_with(404) }
      specify { expect(response.body).to match(/Couldn't find Booking/) }
    end
  end

end
