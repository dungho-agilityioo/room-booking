require 'rails_helper'

RSpec.describe RoomsController, type: :controller do
  let!(:rooms) { create_list(:room, 10) }
  let(:room_id) { rooms.first.id }

  describe 'GET /rooms' do
    before { get :index }

    it { should respond_with(200) }

    it 'returns rooms' do
      rs = JSON.parse(response.body)
      expect(rs).not_to be_empty
      expect(rs.size).to eq(10)
    end
  end

  describe 'GET /rooms/:id' do
    before { get :show, { id: room_id } }

    context 'when the room exists' do
      it { should respond_with(200) }

      it 'return the room' do
        room = JSON.parse(response.body)
        expect(room).not_to be_empty
        expect(room['id']).to eq(room_id)
      end
    end

    # context 'when the room does not exists' do
    #   let(:room_id) { 1000 }

    #   it { should respond_with(404) }

    # end
  end

  describe 'POST /rooms' do
  end
end
