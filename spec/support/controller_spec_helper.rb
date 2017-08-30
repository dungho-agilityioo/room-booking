module ControllerSpecHelper
  # Parse JSON response to ruby hash
  def json
    JSON.parse(response.body)['data']
  end

  # generate tokens from user id
  def token_generator(id)
    JsonWebToken.encode(id: id)
  end

  # generate expired tokens from user id
  def expired_token_generator(id)
    JsonWebToken.encode({ id: id }, (Time.now.to_i - 10))
  end

  # return valid headers
  def valid_headers
    {
      "Authorization" => token_generator(user.id),
      "Content-Type" => "application/json"
    }
  end

  # return invalid headers
  def invalid_headers
    {
      "Authorization" => nil,
      "Content-Type" => "application/json"
    }
  end
end
