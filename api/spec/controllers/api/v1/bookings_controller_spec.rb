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
        params = FactoryGirl.attributes_for(:booking)
                  .merge(room_id: room.id, daily: true)
        post :create, params: params
      end

      it { should respond_with(201) }
      it 'should be state is conflict' do
        expect(json['state']).to eq('conflict')
      end
      it 'should not generate next booking' do
        expect(Booking.where(booking_ref_id: json['id']).count).to eq(0)
      end
    end

    context 'when the room is overlaps in the same user' do
      before { post :create, params: FactoryGirl.attributes_for(:booking).merge(room_id: room.id) }

      it { should respond_with(422) }
      specify { expect(response.body).to match(/#{I18n.t('errors.messages.booking_overlap')}/) }
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
    let!(:booking) { create(:booking, room: room, user: user ) }
    let(:valid_attributes) { FactoryGirl.attributes_for(:booking).merge( room_id: room.id, type: :update ) }

    context '#update' do
      before {
        put :update, params: valid_attributes
                                  .merge(title: "Booking for scrum")
                                  .merge(id: booking.id)
      }

      it { should respond_with(200) }
      specify { expect(json["title"]).to eq('Booking for scrum') }
    end

    context '#activate' do
      let!(:user2) { create(:user) }
      let!(:booking2) { create(:booking, room: room, user: user2 ) }

      context 'before activate' do
        specify { expect(booking.state).to eq('available') }
        specify { expect(booking2.state).to eq('conflict') }
      end

      context 'after activate' do
        before {
          request.headers["Authorization"] = token_generator(user2.id)
          put :update, params: { id: booking2.id, room_id: room.id, type: :activate }
        }

        it 'should be change state booking2 to available' do
          booking2.reload
          expect(booking2.state).to eq("available")
        end

        it 'should be change state booking to conflict' do
          booking.reload
          expect(booking.state).to eq("conflict")
        end
      end
    end

    context '#reopen' do
      let!(:booking2) { create(:booking_all_now, daily: true, user: user ) }
      before { booking2.remove }

      context 'before reopen' do
        specify { expect(Booking.where(booking_ref_id: booking2.id).count).to eq(0) }
      end

      context 'after reopen' do
        before { put :update, params: { id: booking2.id, room_id: room.id, type: :reopen } }
        specify { expect(booking.state).to eq('available') }
        specify { expect(Booking.where(booking_ref_id: booking2.id).count).to eq(6) }
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
