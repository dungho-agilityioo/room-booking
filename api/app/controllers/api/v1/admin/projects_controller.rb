module Api
  module V1
    module Admin
      class ProjectsController < ApplicationController
        before_action :find_project, only: [:show, :update, :destroy]
        swagger_controller :room, "Project Management"

        # GET /projects
        # :nocov:
        swagger_api :index do
          summary "Fetches all Projects"
          param :query, :page, :integer, :optional, "Page Number"
          response :ok, "Success", :Project
          response :unauthorized
          response :not_found
        end
        # :nocov:
        def index
          authorize Project
          param! :page, Integer
          page = params[:page].present? && params[:page] || 1
          total = Project.count
          projects = Project.includes(:users).page(page)

          respone_collection_serializer(projects, page, total, ProjectSerializer)
        end

        # GET /projects/:id
        # :nocov:
        swagger_api :show do
          summary "Fetches a single Project item"
          param :path, :id, :integer, :required, "Project Id"
          response :ok, "Success", :Project
          response :unauthorized
          response :not_found
        end
        # :nocov:
        def show
          authorize @project
          json_response(@project)
        end

        # POST /projects
        # :nocov:
        swagger_api :create do
          summary "Creates a new Project"
          param :form, :name, :string, :required, "Project Name"
          response :created, "Success", :Project
          response :unauthorized
        end
        # :nocov:
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
        # :nocov:
        swagger_api :update do
          summary "Update a Project"
          param :path, :id, :integer, :required, "Project Id"
          param :form, :name, :string, :required, "Project Name"
          param_list :form, :status, :string, :required, "Status", [:active, :inactive]
          response :ok, "Success", :Project
          response :unauthorized
          response :not_found
        end
        # :nocov:
        def update
          authorize @project
          if @project.update(project_params)
            json_response(@project, :ok)
          else
            json_response(@project.errors.full_messages, :unprocessable_entity)
          end
        end

        # DELETE /projects/:id
        # :nocov:
        swagger_api :destroy do
          summary "Delete a Project"
          param :path, :id, :integer, :required, "Project Id"
          response :no_content, "Success", :Project
          response :unauthorized
          response :not_found
        end
        # :nocov:
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
          @project = Project.includes(:users).find(params[:id])
        end
      end
    end
  end
end
