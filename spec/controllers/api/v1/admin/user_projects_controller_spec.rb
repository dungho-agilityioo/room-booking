require 'rails_helper'

RSpec.describe Api::V1::Admin::UserProjectsController, type: :controller do
  let!(:users) { create_list(:user, 4) }
  let!(:user) { create(:user, role: :admin) }
  let!(:project) { create(:project) }
  let!(:project_id) { project.id }
  let!(:valid_attributes) { { project_id: project_id, user_id: users.map { |u| u.id } } }

  let(:headers) { valid_headers }

  before(:each) { request.headers["Authorization"] = headers["Authorization"] }

  describe 'GET /user_projects' do
    before { post :create, params: valid_attributes }
    before { get :index }

    it { should respond_with(200) }

    it 'returns user_projects' do
      expect(json).not_to be_empty
      expect(json.size).to eq(4)
    end

    it 'return correct the metadata' do
      expect(JSON.parse(response.body)["metadata"]["page"].to_i).to eq(1)
      expect(JSON.parse(response.body)["metadata"]["total"].to_i).to eq(4)
      expect(JSON.parse(response.body)["metadata"]["total_page"].to_i).to eq(1)
    end
  end
  describe 'POST /user_projects' do

    context 'when the request is valid' do

      before { post :create, params: valid_attributes }

      it { should respond_with(201) }

      it 'should create the sucessfully' do
        expect(json["id"].to_i).to eq(project_id)
      end

      it 'should be assign user' do
        user_ids = json["users"].map { |u| u["id"].to_i }
        expect( user_ids.sort ).to eq(users.map { |u| u.id })
      end

    end

    context 'when the request is missing the project_id' do
      before { post :create, params: {  user_id: user.id } }

      it { should respond_with(400) }

      it 'return a validation failure message' do
        expect(response.body).to match(/Parameter project_id is required/)
      end
    end

    context 'when the request is missing the user_id' do
      before { post :create, params: { project_id: project_id } }

      it { should respond_with(400) }

      it 'return a validation failure message' do
        expect(response.body).to match(/Parameter user_id is required/)
      end
    end

  end

  describe 'PUT /user_projects/:project_id' do

    let(:valid_attributes) { { project_id: project_id, user_id: users.map { |u| u.id } } }

    context 'when the request is valid' do

      before { put :update, params: valid_attributes }

      it { should respond_with(200) }

      it 'should update the sucessfully' do
        expect(json["id"].to_i).to eq(project_id)
      end

      it 'should be assign user' do
        user_ids = json["users"].map { |u| u["id"].to_i }
        expect( user_ids.sort ).to eq(users.map { |u| u.id })
      end

    end

    context 'when the request is missing the user_id' do
      before { put :update, params: { project_id: project_id } }

      it { should respond_with(400) }

      it 'return a validation failure message' do
        expect(response.body).to match(/Parameter user_id is required/)
      end
    end

  end

  describe 'DELETE /user_projects/:project_id' do
    before { post :create, params: valid_attributes }

    it { expect(json.size).to eq(4) }

    context 'with project id is exists' do
      before { delete :destroy, params: { project_id: project_id } }

      it { should respond_with(204) }
    end

    context 'with project id do not exists' do
      before { delete :destroy, params: { project_id: project_id + 2 } }

      it { should respond_with(404) }
      it 'should be not found message' do
        expect(response.body).to match(/Couldn't find Project with/)
      end
    end

  end
end
