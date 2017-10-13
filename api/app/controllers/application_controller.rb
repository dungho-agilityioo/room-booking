class ApplicationController < ActionController::Base
  include Response
  include ExceptionHandler
  include Pundit

  before_action :authenticate_request
  attr_reader :current_user

  # :nocov:
  def self.add_common_params(api)
    api.param :path, :room_id, :integer, :required, "Room Id"
    api.param :form, :start_date, :DateTime, :required, "Time Start"
    api.param :form, :end_date, :DateTime, :required, "Time End"
  end
  # :nocov:
  class << self
    Swagger::Docs::Generator::set_real_methods
  end
  private

  def authenticate_request
    @current_user = AuthorizeApiRequest.call(request.headers).result[:user]
  end
end
