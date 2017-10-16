require 'rails_helper'

RSpec.describe Api::V1::RoomsController, type: :controller do

  let(:user) { create(:user, role: :admin) }
  let(:room_id) { create(:room).id }
  # authorize request
  let(:headers) { valid_headers }

  before(:each) { request.headers["Authorization"] = headers["Authorization"] }

  describe 'GET /rooms' do
    context '#getall' do
      let!(:rooms) { create_list(:room, 15) }
      before { get :index }

      it { should respond_with(200) }
      specify { expect(json).not_to be_empty }
      specify { expect(json.size).to eq(15) }

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

    context 'when room that has already been booking' do
      before(:each) do
        room = create(:room)
        create(:booking_with_room, room: room)
        delete :destroy, params: { id: room.id }
      end

      it { should respond_with(500) }
      specify { expect(response.body).to match(/cannot delete room that has already been booking/) }
    end
  end

end
