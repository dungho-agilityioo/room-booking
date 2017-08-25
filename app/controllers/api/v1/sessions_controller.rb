class Api::V1::SessionsController < Devise::SessionsController

  def create

    oauth_login = request.env['omniauth.auth']

    raise Devise::InvalidLogin unless oauth_login.present?

    @resource = User.from_omniauth(oauth_login)

    @resource = auth_resource

    sign_in @resource

    render json: @resource, serializer: serializer
  end

  def destroy
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    render status: :ok, json: { success: true }
  end

  protected

  def auth_resource
    User.find_for_database_authentication(email: params[:email])
  end

  def serializer
    UserSerializer
  end
end
