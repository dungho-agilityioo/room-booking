
require 'json_web_token'

class LoginSerializer < UserSerializer
  attributes :auth_token

  def auth_token
    iat = object.current_sign_in_at.to_i
    secret = Rails.application.secrets.secret_key_base
    JsonWebToken.encode(object.slice(:id, :email).merge({ iat: iat }), secret)
  end
end
