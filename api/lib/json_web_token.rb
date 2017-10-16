class JsonWebToken
  class << self
    HMAC_SECRET = Rails.application.secrets.secret_key_base
    def encode(payload, exp = 6.months.from_now)
      # set expiry to 24 hours from creation time
      payload[:exp] = exp.to_i
      # sign token with application secret
      JWT.encode(payload, HMAC_SECRET)
    end

    def decode(token)
      # get payload; first index in decoded Array
      body = JWT.decode(token, HMAC_SECRET)[0]
      HashWithIndifferentAccess.new body
      # rescue from expiry exception
      rescue JWT::ExpiredSignature, JWT::VerificationError => e
      # raise custom error to be handled by custom handler
      raise ExceptionHandler::ExpiredSignature, e.message
    end
  end
end
