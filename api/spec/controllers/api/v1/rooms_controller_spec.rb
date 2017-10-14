require 'rails_helper'

RSpec.describe Api::V1::RoomsController, type: :controller do

  let(:user) { create(:user, role: :admin) }
  let(:room_id) { create(:room).id }
  # authorize request
  let(:headers) { valid_headers }

  before(:each) { request.headers["Authorization"] = headers["Authorization"] }

  describe 'GET /rooms' do
    let!(:rooms) { create_list(:room, 15) }

    context '#getall' do

      context '#limit, #offset is blank' do
        before { get :index }

        it { should respond_with(200) }
        specify { expect(json).not_to be_empty }
        specify { expect(json.size).to eq(10) }
        specify { expect(metadata['total']).to eq(15) }

      end

      context '#limit, #offset is present' do
        before { get :index, params: { limit: 8, offset: 8 } }

        it { should respond_with(200) }
        specify { expect(json).not_to be_empty }
        specify { expect(json.size).to eq(7) }
        specify { expect(metadata['total']).to eq(15) }

      end
    end

    context '#filter' do
      before(:all) do
        15.times do |t|
          create(
              :booking_all,
              start_date: Date.today.next_week + t.hours,
              end_date: Date.today.next_week + t.hours + 30.minutes
            )
        end
      end
      context '#booked' do

        context 'when the request valid' do

          context '#limit, #offset is blank' do
            before {
              get :index, params: {
                filter: 'booked',
                start_date: Date.today.next_week + 3.hours,
                end_date: Date.today.next_week + 7.hours
              }
            }
            it { should respond_with(200) }
            specify { expect(json.size).to eq(5) }
            specify { expect(metadata['total']).to eq(5) }
          end

          context '#limit, #offset is present' do
            before {
              get :index, params: {
                filter: 'booked',
                start_date: Date.today.next_week + 3.hours,
                end_date: Date.today.next_week + 15.hours,
                limit: 7,
                offset: 4
              }
            }

            it { should respond_with(200) }
            specify { expect(json.size).to eq(7) }
            specify { expect(metadata['total']).to eq(12) }
          end
        end

        context 'when the request invalid' do
          before { get :index, params: { filter: 'booked' } }

          it { should respond_with(400) }

          specify { expect(response.body).to match(/Parameter start_date is required/) }
        end
      end

      context '#available' do
        context 'when the request valid' do

          context '#limit, #offset is blank' do
            before {
              get :index, params: {
                filter: 'available',
                start_date: Date.today.next_week + 3.hours,
                end_date: Date.today.next_week + 7.hours
              }
            }
            it { should respond_with(200) }
            specify { expect(json.size).to eq(5) }
            specify { expect(metadata['total']).to eq(5) }
          end
        end

        context 'when the request invalid' do
          before { get :index, params: { filter: 'available' } }

          it { should respond_with(400) }

          specify { expect(response.body).to match(/Parameter start_date is required/) }
        end
      end
    end

  end

  describe 'GET /rooms/:id' do
    before { get :show, params: { id: room_id } }

    context 'when the record exists' do
      it { should respond_with(200) }

      it 'return the record' do
        expect(json).not_to be_empty
        expect(json['id'].to_i).to eq(room_id)
      end
    end

    context 'when the record does not exists' do
      let(:room_id) { 1000 }

      it { should respond_with(404) }
      specify { expect(response.body).to match(/Couldn't find Room/) }
    end
  end

  describe 'POST /rooms' do
    let(:valid_attributes) { FactoryGirl.attributes_for(:room) }

    context 'when the request is valid' do
      before { post :create, params: valid_attributes }

      it { should respond_with(201) }

      it 'creates a room' do
        expect(json['name']).to eq(valid_attributes[:name])
      end
    end

    context 'when the request is invalid' do
      before { post :create, params: { name: '' } }

      it { should respond_with(422) }
      specify { expect(response.body).to match(/Name can't be blank/) }
    end

  end

  describe 'PUT /rooms/:id' do
    let(:valid_attributes) { FactoryGirl.attributes_for(:room) }

    context 'when the record exists' do
      before { put :update, params: valid_attributes.merge( id: room_id) }

      it { should respond_with(200) }
      specify { expect(json['name']).to eq(valid_attributes[:name]) }
    end

    context 'when the request is invalid' do
      before { put :update, params: {id: room_id, name: '' } }

      it { should respond_with(422) }
      specify { expect(response.body).to match(/Name can't be blank/) }
    end

    context 'when the record do not exists' do
      before { post :update, params: {id: 39393} }

      it { should respond_with(404) }
      specify { expect(response.body).to match(/Couldn't find Room/) }
    end
  end

  describe 'DELETE /rooms/:id' do

    context 'when the record is exists' do
      before { delete :destroy, params: { id: room_id } }

      it { should respond_with(204) }
    end

    context 'when the record do not exists' do
      before { delete :destroy, params: { id: 83872 } }

      it { should respond_with(404) }
      specify { expect(response.body).to match(/Couldn't find Room/) }
    end
  end

end
