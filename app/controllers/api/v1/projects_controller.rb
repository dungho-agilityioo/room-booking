class Api::V1::ProjectsController < ApplicationController
  before_action :find_project, only: [:show, :update, :destroy]

  # GET /projects
  def index
    @projects = Project.all
    json_response(@projects)
  end

  # GET /projects/:id
  def show
    json_response(@project)
  end

  # POST /projects
  def create
    @project = Project.new(project_params)
    if @project.save
      json_response(@project, :created)
    else
      json_response(@project.errors.full_messages, :unprocessable_entity)
    end
  end

  # PUT /projects
  def update
    if @project.update(project_params)
      json_response(@project, :ok)
    else
      json_response(@project.errors.full_messages, :unprocessable_entity)
    end
  end

  # DELETE /projects/:id
  def destroy
    @project.destroy
    json_response( nil, :no_content)
  end

  private

  def project_params
    # whitelist params
    params.require(:project).permit(:name, :status)
  end

  def find_project
    @project = Project.find(params[:id])
  end
end
