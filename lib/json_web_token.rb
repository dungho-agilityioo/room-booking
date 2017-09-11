class JsonWebToken
  class << self

    def encode(payload, secret, exp = 24.hours.from_now)
      # set expiry to 24 hours from creation time
      payload[:exp] = exp.to_i
      # sign token with application secret
      JWT.encode(payload, secret)
    end

    def decode(token, secret)
      # get payload; first index in decoded Array
      body = JWT.decode(token, secret)[0]
      HashWithIndifferentAccess.new body
      # rescue from expiry exception
      rescue JWT::ExpiredSignature, JWT::VerificationError => e
      # raise custom error to be handled by custom handler
      raise ExceptionHandler::ExpiredSignature, e.message
    end
  end
end
