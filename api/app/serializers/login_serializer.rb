
require 'json_web_token'

class LoginSerializer < UserSerializer
  attributes :auth_token

  def auth_token
    iat = object.current_sign_in_at.to_i
    JsonWebToken.encode(object.slice(:id, :email).merge({ iat: iat }))
  end
end
