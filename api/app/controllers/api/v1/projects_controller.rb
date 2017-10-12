module Api
  module V1
    class ProjectsController < ApplicationController
      before_action :find_project, only: [:show, :update, :destroy, :assign_user]
      swagger_controller :room, "Project Management"

      # GET /projects
      # :nocov:
      swagger_api :index do
        summary "Fetches all Projects of Current User"
        param :query, :page, :integer, :optional, "Page Number"
        response :ok, "Success", :Project
        response :unauthorized
        response :not_found
      end
      # :nocov:
      def index
        authorize Project
        param! :page, Integer
        page = params[:page].present? && params[:page].to_i || 1

        if @current_user.admin?
          total = Project.count
          projects = Project.includes(:users).page(page)
        else
          total = @current_user.projects.count
          projects = @current_user.projects.active.select(:id, :name, :status)
        end

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
        respone_record_serializer(@project, ProjectSerializer)
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
        @project.save!
        respone_record_serializer(@project, ProjectSerializer, :created)
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
        @project.update!(project_params)
        respone_record_serializer(@project, ProjectSerializer, :ok)
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

      # Assign user to a project
      # PUT /projects/:id/assign
      # :nocov:
      swagger_api :assign_user do
        summary "Assign user to a project"
        param :path, :id, :integer, :required, "Project Id"
        param :form, :user_ids, :integer, :required, "User Ids (separated by commas)"
        response :created, "Success", :UserProject
        response :unauthorized
      end
      # :nocov:
      def assign_user
        authorize Project
        param! :user_ids, Array, required: true
        @project.user_ids = params[:user_ids]
        respone_record_serializer(@project, ProjectSerializer, :created)
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
