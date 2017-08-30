class ApplicationController < ActionController::Base
  include Response
  include ExceptionHandler
  include Pundit

  before_action :authenticate_request
  attr_reader :current_user

  private

  def authenticate_request
    @current_user = AuthorizeApiRequest.call(request.headers).result[:user]
    json_response({ error: Message.unauthorized }, 401) unless @current_user
  end
end
