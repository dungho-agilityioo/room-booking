module ControllerSpecHelper
  HMAC_SECRET = Rails.application.secrets.secret_key_base
  # Parse JSON response to ruby hash
  def json
    JSON.parse(response.body)['data']
  end

  # generate tokens from user id
  def token_generator(id)
    token = JsonWebToken.encode({id: id}, HMAC_SECRET)
    "Bearer #{token}"
  end

  # generate expired tokens from user id
  def expired_token_generator(id)
    token = JsonWebToken.encode({ id: id }, HMAC_SECRET, (Time.now.to_i - 10))
    "Bearer #{token}"
  end

  # return valid headers
  def valid_headers
    {
      "Authorization" => token_generator(user.id),
      "Content-Type" => "application/json"
    }
  end

end
