class Api::V1::ProjectsController < ApplicationController
  before_action :find_project, only: [:show, :update, :destroy]
  swagger_controller :room, "Project Management"

  # GET /projects
  swagger_api :index do
    summary "Fetches all Projects"
    response :ok, "Success", :Project
    response :unauthorized
    response :not_found
  end
  def index
    @projects = Project.all
    authorize Project
    json_response(@projects)
  end

  # GET /projects/:id
  swagger_api :show do
    summary "Fetches a single Project item"
    param :path, :id, :integer, :required, "Project Id"
    response :ok, "Success", :Project
    response :unauthorized
    response :not_found
  end
  def show
    authorize @project
    json_response(@project)
  end

  # POST /projects
  swagger_api :create do
    summary "Creates a new Project"
    param :form, :name, :string, :required, "Project Name"
    response :ok, "Success", :Project
    response :unauthorized
    response :not_found
  end
  def create
    @project = Project.new(project_params)
    authorize @project
    if @project.save
      json_response(@project, :created)
    else
      json_response(@project.errors.full_messages, :unprocessable_entity)
    end
  end

  # PUT /projects
  swagger_api :update do
    summary "Update a new Project"
    param :path, :id, :integer, :required, "Project Id"
    param :form, :name, :string, :required, "Project Name"
    param_list :form, :status, :string, :required, "Status", [:active, :inactive]
    response :ok, "Success", :Project
    response :unauthorized
    response :not_found
  end
  def update
    authorize @project
    if @project.update(project_params)
      json_response(@project, :ok)
    else
      json_response(@project.errors.full_messages, :unprocessable_entity)
    end
  end

  # DELETE /projects/:id
  swagger_api :destroy do
    summary "Delete a new Project"
    param :path, :id, :integer, :required, "Project Id"
    response :no_content, "Success", :Project
    response :unauthorized
    response :not_found
  end
  def destroy
    authorize @project
    @project.destroy
    json_response( nil, :no_content)
  end

  private

  def project_params
    # whitelist params
    params.permit(:name, :status)
  end

  def find_project
    @project = Project.find(params[:id])
  end
end
