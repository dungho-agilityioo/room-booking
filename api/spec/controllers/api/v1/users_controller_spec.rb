require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  let!(:user) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:project) { create(:project) }
  let!(:project2) { create(:project) }

  let(:headers) { valid_headers }

  before(:each) { request.headers["Authorization"] = headers["Authorization"] }

  describe 'GET /projects' do
    before do
      create(:user_project, user: user, project: project)
      create(:user_project, user: user, project: project2)
      create(:user_project, user: user2, project: project)

      get :projects
    end

    it { should respond_with(200) }

    it 'returns list projects of current user' do
      expect(json).not_to be_empty
      expect(json.size).to eq(2)
    end

  end
end
