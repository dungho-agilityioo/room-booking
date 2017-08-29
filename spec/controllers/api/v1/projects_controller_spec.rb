require 'rails_helper'

RSpec.describe Api::V1::ProjectsController, type: :controller do
  let!(:projects) { create_list(:project, 10) }
  let(:project_id) { projects.first.id }

  def setup
    @request.env["devise.mapping"] = Devise.mappings[:admin]
    # sign_in FactoryGirl.create(:admin)
  end

  describe 'GET /projects' do
    before { get :index }

    it { should respond_with(200) }

    it 'returns projects' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end
  end

  describe 'GET /projects/:id' do
    before { get :show, params: { id: project_id } }

    context 'when the record exists' do
      it { should respond_with(200) }

      it 'return the record' do
        expect(json['id']).to eq(project_id)
      end
    end

    context 'when the record do not exists' do
      let(:project_id) { 1000 }

      it { should respond_with(404) }

      it 'return a not found message' do
        expect(response.body).to match(/Couldn't find Project/)
      end
    end

  end

  describe 'POST /projects' do
    let(:valid_attributes) { FactoryGirl.attributes_for(:project) }

    context 'when the request is valid' do
      before { post :create, params: { project: valid_attributes } }

      it { should respond_with(201) }

      it 'create a project' do
        expect(json['name']).to eq(valid_attributes[:name])
      end

      it 'with status is active' do
        expect(json['status']).to eq('active')
      end
    end

    context 'when the request is invalid' do
      before { post :create, params: { project: { name: '' } } }

      it { should respond_with(422) }

      it 'return a validation failure message' do
        expect(response.body).to match(/Name can't be blank/)
      end
    end
  end

  describe 'PUT /projects/:id' do
    let(:valid_attributes) { FactoryGirl.attributes_for(:project) }

    context 'when the record exists' do
      before { put :update, params: { id: project_id, project: valid_attributes } }

      it { should respond_with(200) }

      it 'updates the record' do
        expect(json['name']).to eq(valid_attributes[:name])
      end
    end

    context 'when the record do not exists' do
      before { put :update, params: {id: project_id, project: { name: '' } } }

      it { should respond_with(422) }

      it 'return a validation failure message' do
        expect(response.body).to match(/Name can't be blank/)
      end
    end
  end

  describe 'DELETE /rooms/:id' do
    before { delete :destroy, params: { id: project_id } }

    it { should respond_with(204) }
  end
end
