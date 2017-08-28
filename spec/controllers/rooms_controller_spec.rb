require 'rails_helper'

RSpec.describe Api::V1::RoomsController, type: :controller do
  let!(:rooms) { create_list(:room, 10) }
  let(:room_id) { rooms.first.id }

  describe 'GET /rooms' do
    before { get :index }

    it { should respond_with(200) }

    it 'returns rooms' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end
  end

  describe 'GET /rooms/:id' do
    before { get :show, params: { id: room_id } }

    context 'when the record exists' do
      it { should respond_with(200) }

      it 'return the record' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(room_id)
      end
    end

    context 'when the record does not exists' do
      let(:room_id) { 1000 }

      it { should respond_with(404) }

      it 'return a not found message' do
        expect(response.body).to match(/Couldn't find Room/)
      end
    end
  end

  describe 'POST /rooms' do
    let(:valid_attributes) { FactoryGirl.attributes_for(:room) }

    context 'when the request is valid' do
      before { post :create, params: { room: valid_attributes } }

      it { should respond_with(201) }

      it 'creates a room' do
        expect(json['name']).to eq(valid_attributes[:name])
      end
      # it do
      #   should permit(:name).for(:create, params: valid_attributes)
      # end
    end

    context 'when the request is invalid' do
      before { post :create, params: { room: { name: '' } } }

      it { should respond_with(422) }

      it 'return a validation failure message' do
        expect(response.body).to match(/Name can't be blank/)
      end
    end

  end

  describe 'PUT /rooms/:id' do
    let(:valid_attributes) { FactoryGirl.attributes_for(:room) }

    context 'when the record exists' do
      before { put :update, params: { id: room_id, room: valid_attributes } }

      it { should respond_with(200) }

      it 'updates the record' do
        expect(json['name']).to eq(valid_attributes[:name])
      end
    end

    context 'when the request is invalid' do
      before { put :update, params: {id: room_id, room: { name: '' } } }

      it { should respond_with(422) }

      it 'return a validation failure message' do
        expect(response.body).to match(/Name can't be blank/)
      end
    end
  end

  describe 'DELETE /rooms/:id' do
    before { delete :destroy, params: { id: room_id } }

    it { should respond_with(204) }
  end

end
