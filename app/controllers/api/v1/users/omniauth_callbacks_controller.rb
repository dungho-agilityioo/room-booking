class Api::V1::Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :oauth_login, only: [:gitlab]

  def gitlab
    @resource = auth_resource

    raise Devise::InvalidLogin unless @resource.present?

    sign_in @resource, store: false

    render json: @resource
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
