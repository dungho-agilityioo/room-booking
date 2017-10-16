module ControllerSpecHelper
  # Parse JSON response to ruby hash
  def json
    JSON.parse(response.body)['data']
  end

  def metadata
    JSON.parse(response.body)["metadata"]
  end

  # generate tokens from user id
  def token_generator(id)
    token = JsonWebToken.encode({id: id})
    "Bearer #{token}"
  end

  # generate expired tokens from user id
  def expired_token_generator(id)
    token = JsonWebToken.encode({ id: id }, (Time.now.to_i - 10))
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
