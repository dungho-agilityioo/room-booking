class Api::V1::Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :oauth_login, only: [:gitlab]
  skip_before_action :authenticate_request, only: [:gitlab]
  swagger_controller :user, "User Management"

  def gitlab
    @resource = auth_resource

    raise Devise::InvalidLogin unless @resource.present?

    sign_in @resource, store: false

    render json: @resource
  end

  swagger_api :destroy do |api|
    summary "Logout"
    response :ok, "Success", :OmniauthCallbacks
    response :unauthorized
  end
  def destroy
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    render status: :ok, json: { success: true }
  end

  protected

  def oauth_login
    oauth_login = request.env['omniauth.auth']
    User.from_omniauth(oauth_login)
  end

  def auth_resource

    user = oauth_login

    User.find_for_database_authentication(email: user[:email])
  end
end
