class ApplicationController < ActionController::API
  include Response
  include ExceptionHandler

  def new_session_path(scope)
    api_v1_new_user_session_path
  end
end
