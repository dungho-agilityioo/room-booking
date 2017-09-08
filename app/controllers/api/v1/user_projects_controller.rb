class Api::V1::UserProjectsController < ApplicationController

  # GET /user_projects
  def index
    page = params[:page].present? && params[:page] || 1
    total = UserProject.count
    user_projects = UserProject.includes(:user, :project).page(page)
    respone_collection_serializer(user_projects, page, total, UserProject)
  end

  # POST /user_projects
  def create
    param! :project_id, Integer, required: true
    param! :user_id, Array, required: true
    find_project
    @project.user_ids = params[:user_id]
    respone_record_serializer(@project, ProjectSerializer, :created)
  end

  # PUT /user_projects
  def update
    param! :project_id, Integer, required: true
    param! :user_id, Array, required: true
    find_project
    @project.user_ids = params[:user_id]
    respone_record_serializer(@project, ProjectSerializer)
  end

  # DELETE /user_projects/:id
  def destroy
    user_project = UserProject.find(params[:id])

    user_project.destroy
    json_response(nil, :no_content)
  end

  private

  def find_project
    @project = Project.find(params[:project_id])
  end
end
