class JsonWebToken
  class << self
    def encode(payload, exp = 24.hours.from_now)
      payload[:exp] = exp.to_i
      JWT.encode(payload, Rails.application.secrets.secret_key_base)
    end

    def decode(token)
      # get payload; first index in decoded Array
      body = JWT.decode(token, Rails.application.secrets.secret_key_base)[0]
      HashWithIndifferentAccess.new body
      # rescue from expiry exception
      rescue JWT::ExpiredSignature, JWT::VerificationError => e
        # raise custom error to be handled by custom handler
        raise ExceptionHandler::ExpiredSignature, e.message
    end
  end
end
