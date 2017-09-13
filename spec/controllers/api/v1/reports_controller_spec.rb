require 'rails_helper'

RSpec.describe Api::V1::ReportsController, type: :controller do
  let!(:user) { create(:user, role: :admin) }
  let(:headers) { valid_headers }

  before(:all) do
    @room =  create(:room)
    @room2 =  create(:room)
    @project =  create(:project)
    @project2 =  create(:project)
    @user =  create(:user, role: :admin)

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
        time_start: Date.today.next_week + 14.hours,
        time_end: Date.today.next_week + 15.hours,
      },
      {
        time_start: Date.today.next_week + 15.hours,
        time_end: Date.today.next_week + 16.hours,
      },
      {
        time_start: Date.today.next_week + 16.hours,
        time_end: Date.today.next_week + 17.hours,
      },
      {
        time_start: Date.today.next_week + 1.day + 8.hours,
        time_end: Date.today.next_week + 1.day + 9.hours,
      },
      {
        time_start: Date.today.next_week + 1.day + 9.hours,
        time_end: Date.today.next_week + 1.day + 10.hours,
      },
      {
        time_start: Date.today.next_week + 1.day + 10.hours,
        time_end: Date.today.next_week + 1.day + 11.hours,
      },
      {
        time_start: Date.today.next_week + 1.day + 14.hours,
        time_end: Date.today.next_week + 1.day + 15.hours,
      },
      {
        time_start: Date.today.next_week + 1.day + 15.hours,
        time_end: Date.today.next_week + 1.day + 16.hours,
      },
      {
        time_start: Date.today.next_week + 1.day + 16.hours,
        time_end: Date.today.next_week + 1.day + 17.hours,
      },
    ]

    available_date.each do |date|
      @user.book! @room, time_start: date[:time_start], time_end: date[:time_end], project_id: @project.id, amount: 1, title: Faker::Lorem.sentence
    end

    @user.book! @room2, time_start: Date.today.next_week + 8.hours, time_end: Date.today.next_week + 10.hours, project_id: @project2.id, amount: 1
  end

  before(:each) { request.headers["Authorization"] = headers["Authorization"] }

  describe 'GET /index' do

    context '#date' do
      context '#page 1' do
        before do
          get :index, params: {
                      type: 'date',
                      room_id: @room.id,
                      time_start: Date.today.next_week + 8.hours,
                      time_end: Date.today.next_week + 1.day + 17.hours
                    }
        end

        it { should respond_with(200) }

        it 'return room bookings' do
          expect(json.count).to eq(10)
        end

        it 'return correct number of page' do
          expect(metadata["page"].to_i).to eq(1)
        end

        it 'return correct number of per_page' do
          expect(metadata["per_page"].to_i).to eq(10)
        end

        it 'return correct number of total' do
          expect(metadata["total"].to_i).to eq(12)
        end

        it 'return correct number of total page' do
          expect(metadata["total_page"].to_i).to eq(2)
        end
      end

      context '#page 2' do
        before do
          get :index, params: {
                      type: 'date',
                      page: 2,
                      room_id: @room.id,
                      time_start: Date.today.next_week + 8.hours,
                      time_end: Date.today.next_week + 1.day + 17.hours
                    }
        end

        it { should respond_with(200) }

        it 'return room bookings' do
          expect(json.count).to eq(2)
        end

        it 'return correct number of page' do
          expect(metadata["page"].to_i).to eq(2)
        end

        it 'return correct number of per_page' do
          expect(metadata["per_page"].to_i).to eq(10)
        end

        it 'return correct number of total' do
          expect(metadata["total"].to_i).to eq(12)
        end

        it 'return correct number of total page' do
          expect(metadata["total_page"].to_i).to eq(2)
        end
      end
    end

    describe '#project' do

      context '#page 1' do
        before  { get :index, params: { type: 'project', project_id: @project.id } }

        it { should respond_with(200) }

        it 'return room bookings' do
          expect(json.count).to eq(10)
        end

        it 'return correct number of page' do
          expect(metadata["page"].to_i).to eq(1)
        end

        it 'return correct number of per_page' do
          expect(metadata["per_page"].to_i).to eq(10)
        end

        it 'return correct number of total' do
          expect(metadata["total"].to_i).to eq(12)
        end

        it 'return correct number of total page' do
          expect(metadata["total_page"].to_i).to eq(2)
        end
      end

      context '#page 2' do
        before  { get :index, params: { type: 'project', project_id: @project.id, page: 2 } }

        it { should respond_with(200) }

        it 'return room bookings' do
          expect(json.count).to eq(2)
        end

        it 'return correct number of page' do
          expect(metadata["page"].to_i).to eq(2)
        end

        it 'return correct number of per_page' do
          expect(metadata["per_page"].to_i).to eq(10)
        end

        it 'return correct number of total' do
          expect(metadata["total"].to_i).to eq(12)
        end

        it 'return correct number of total page' do
          expect(metadata["total_page"].to_i).to eq(2)
        end
      end
    end
  end


end
