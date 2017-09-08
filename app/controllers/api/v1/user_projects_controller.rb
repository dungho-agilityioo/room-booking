class Api::V1::UserProjectsController < ApplicationController
  before_action :find_project, only: [:update, :destroy]

  # GET /user_projects
  def index
    authorize UserProject
    page = params[:page].present? && params[:page] || 1
    total = UserProject.count
    user_projects = UserProject.includes(:user, :project).page(page)
    respone_collection_serializer(user_projects, page, total, UserProject)
  end

  # POST /user_projects
  def create
    authorize UserProject
    param! :project_id, Integer, required: true
    param! :user_id, Array, required: true
    find_project
    @project.user_ids = params[:user_id]
    respone_record_serializer(@project, ProjectSerializer, :created)
  end

  # PUT /user_projects/:project_id
  def update
    authorize @project
    param! :user_id, Array, required: true
    @project.user_ids = params[:user_id]
    respone_record_serializer(@project, ProjectSerializer)
  end

  # DELETE /user_projects/:project_id
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
