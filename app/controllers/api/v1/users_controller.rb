class Api::V1::UsersController < ApplicationController
  swagger_controller :user, "User Management"

  # GET /users/projects
  swagger_api :projects do
    summary "Fetches all Project of Current User"
    response :ok, "Success", :User
    response :unauthorized
    response :not_found
  end
  def projects
    json_response( { data: @current_user.projects.active } )
  end

end
