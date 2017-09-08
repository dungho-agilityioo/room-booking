class Api::V1::UserProjectsController < ApplicationController
  before_action :find_project, only: [:update, :destroy]
  swagger_controller :user_projects, "Administrator can assign project for user"

  # GET /user_projects
  swagger_api :index do
    summary "Fetches all User Project"
    param :query, :page, :integer, :optional, "Page Number"
    response :ok, "Success", :UserProject
    response :unauthorized
  end
  def index
    authorize UserProject
    page = params[:page].present? && params[:page] || 1
    total = UserProject.count
    user_projects = UserProject.includes(:user, :project).page(page)
    respone_collection_serializer(user_projects, page, total, UserProject)
  end

  # POST /user_projects
  swagger_api :create do |api|
    summary "Creates a new User Project"
    param :form, :project_id, :integer, :required, "Project Id"
    param :form, :user_id, :integer, :required, "User Id"
    response :created, "Success", :UserProject
    response :unauthorized
  end
  def create
    authorize UserProject
    param! :project_id, Integer, required: true
    param! :user_id, Array, required: true
    find_project
    @project.user_ids = params[:user_id]
    respone_record_serializer(@project, ProjectSerializer, :created)
  end

  # PUT /user_projects/:project_id
  swagger_api :update do
    summary "Update a Project User"
    param :path, :project_id, :integer, :required, "Project Id"
    param :form, :user_id, :integer, :required, "User Id"
    response :ok, "Success", :UserProject
    response :unauthorized
    response :not_found
  end
  def update
    authorize @project
    param! :user_id, Array, required: true
    @project.user_ids = params[:user_id]
    respone_record_serializer(@project, ProjectSerializer)
  end

  # DELETE /user_projects/:project_id
  swagger_api :destroy do
    summary "Delete a Project User"
    param :path, :project_id, :integer, :required, "Project Id"
    response :no_content, "Success", :UserProject
    response :unauthorized
    response :not_found
  end
  def destroy
    authorize @project
    @project.user_projects.destroy_all
    json_response(nil, :no_content)
  end

  private

  def find_project
    @project = Project.find(params[:project_id])
  end

end
