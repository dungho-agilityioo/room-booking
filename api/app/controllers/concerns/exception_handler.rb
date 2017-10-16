module ExceptionHandler
  # provides the more graceful `included` method
  extend ActiveSupport::Concern

  # Define custom error subclasses - rescue catches `StandardErrors`
  class AuthenticationError < StandardError; end
  class MissingToken < StandardError; end
  class InvalidToken < StandardError; end
  class ExpiredSignature < StandardError; end
  class BookingDuplicate < StandardError; end

  included do

    # Define custom handlers
    rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity
    rescue_from ExceptionHandler::AuthenticationError, with: :unauthorized_request
    rescue_from ExceptionHandler::MissingToken, with: :unprocessable_entity
    rescue_from ExceptionHandler::InvalidToken, with: :unprocessable_entity
    rescue_from ExceptionHandler::BookingDuplicate, with: :unprocessable_entity
    rescue_from ::Pundit::NotAuthorizedError, with: :pundit_not_authorized
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from ActionController::ParameterMissing, with: :bad_request
    rescue_from RailsParam::Param::InvalidParameterError, with: :bad_request
    rescue_from JWT::DecodeError, with: :unprocessable_entity
    rescue_from ActiveRecord::RecordNotDestroyed, with: :internal_server

    private

    def exception_message(message, status = :unauthorized)
      json_response({ message: message }, status)
    end

    # JSON response with message; Status code 404 - not found
    def not_found(e)
      message = e.message
      message = message[0, message.index('[') - 1] if message.match(/\[/)
      exception_message(message, :not_found)
    end

    # JSON response with message; Status code 422 - unprocessable entity
    def unprocessable_entity(e)
      exception_message(e.message, :unprocessable_entity)
    end

    # JSON response with message; Status code 401 - Unauthorized
    def pundit_not_authorized(e)
      exception_message(Message.unauthorized)
    end

    # JSON response with message; Status code 401 - Unauthorized
    def unauthorized_request(e)
      exception_message(e.message)
    end

    def bad_request(e)
      exception_message(e.message, :bad_request)
    end

    # JSON response with message; Status code 500 - Internal Server Error
    def internal_server(e)
      exception_message(e.message, 500)
    end
  end
end
