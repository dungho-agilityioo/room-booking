class Message
  class << self

    def invalid_token
      'Invalid token'
    end

    def missing_token
      'Missing token'
    end

    def unauthorized
      'Not Authorized'
    end

    def expired_token
      'Signature has expired'
    end

  end
end
