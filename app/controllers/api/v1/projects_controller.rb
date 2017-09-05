class Api::V1::ProjectsController < ApplicationController
  before_action :find_project, only: [:show, :update, :destroy]

  # GET /projects
  def index
    @projects = Project.all
    authorize Project
    json_response(@projects)
  end

  # GET /projects/:id
  def show
    authorize @project
    json_response(@project)
  end

  # POST /projects
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
  def update
    authorize @project
    if @project.update(project_params)
      json_response(@project, :ok)
    else
      json_response(@project.errors.full_messages, :unprocessable_entity)
    end
  end

  # DELETE /projects/:id
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
