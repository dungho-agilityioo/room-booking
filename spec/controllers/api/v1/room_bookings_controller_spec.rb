require 'rails_helper'

RSpec.describe Api::V1::RoomBookingsController, type: :controller do

  let!(:user) { create(:user) }
  let!(:room) { create(:room) }
  let!(:room_booking) { create(:room_booking, bookable: room, booker: user ) }
  let(:room_booking_id) { room_booking.id }

  # authorize request
  let(:headers) { valid_headers }


  before(:each) { request.headers["Authorization"] = headers["Authorization"] }

  describe 'GET /books' do
    before(:each) { get :index }

    it { should respond_with(200) }

    it 'returns list room bookings' do
      expect(json).not_to be_empty
      expect(json.size).to eq(1)
    end
  end

  describe 'GET /books/:id' do
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

  describe 'POST /books' do
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
        expect(json["time_start"].to_datetime).to eq( Date.today.next_week + 1.day + 8.hours )
        expect(json["time_end"].to_datetime).to eq( Date.today.next_week + 1.day + 10.hours - 1.second )
      end

      it 'should be booker is user' do
        expect(json['booker']['user']['id'].to_i).to eq(user.id)
      end

      it 'should be bookable is room' do
        expect(json['bookable']['room']['id'].to_i).to eq(room.id)
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

  describe 'DELETE /books/:id' do

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

  describe 'POST /books/search' do

    describe '#available' do
      let!(:room2) { create(:room) }
      before { create(:booked_with_room, bookable: room2) }

      context 'the Room is available' do
        before(:each) do
          post :search, params: {
                type: "available",
                time_start: Date.today.next_week + 10.hours,
                time_end: Date.today.next_week + 18.hours,
              }
        end

        it { should respond_with(200) }
        it 'return a list rooms available' do
          # include room and room2
          expect(json.size).to eq(2)
        end
      end

      context 'the Room not available' do
        before do
          post :search, params: {
                time_start: Date.today.next_week + 10.hours,
                time_end: Date.today.next_week + 11.hours,
              }
        end

       #  it '' do
       #   should respond_with(201)
       # end
        # it 'return a not found message' do
        #   expect(response.body).to match(/the Room is not available from/)
        # end
      end
    end

    describe '#booked' do
      before(:all) do
        user = create(:user)
        room = create(:room)
        available_date = [
          {
            time_start: Date.today.next_week + 8.hours,
            time_end: Date.today.next_week + 9.hours,
          },
          {
            time_start: Date.today.next_week + 9.hours,
            time_end: Date.today.next_week + 10.hours,
          },
          {
            time_start: Date.today.next_week + 10.hours,
            time_end: Date.today.next_week + 11.hours,
          },
          {
            time_start: Date.today.next_week + 1.day + 14.hours,
            time_end: Date.today.next_week + 1.day + 15.hours,
          }
        ]

        available_date.each do |date|
          user.book! room, time_start: date[:time_start], time_end: date[:time_end], amount: 1
        end
      end

      context 'when enter time param' do
        before { post :search, params: {
            type: 'booked',
            time_start: Date.today.next_week + 9.hours + 30.minute,
            time_end: Date.today.next_week + 12.hours + 30.minute,
          }
        }

        it { should respond_with(200) }

        it 'return room booked' do
          # include booked on top file
          expect(json.count).to eq(3)
        end

        it 'return correct number of page' do
          expect(metadata["page"].to_i).to eq(1)
        end

        it 'return correct number of per_page' do
          expect(metadata["per_page"].to_i).to eq(10)
        end

        it 'return correct number of total' do
          expect(metadata["total"].to_i).to eq(3)
        end

        it 'return correct number of total page' do
          expect(metadata["total_page"].to_i).to eq(1)
        end

      end
      context 'when do not enter param' do
        context '#type param' do
          before { post :search, params: {} }

          it { should respond_with(400) }

          it 'return a error message' do
            expect(response.body).to match(/Parameter type is required/)
          end
        end

        context '#time param' do
          before { post :search, params: { type: 'booked' } }

          it { should respond_with(400) }

          it 'return a error message' do
            expect(response.body).to match(/Parameter time_start is required/)
          end
        end
      end
    end
  end

end
