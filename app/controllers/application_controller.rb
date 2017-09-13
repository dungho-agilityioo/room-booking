class ApplicationController < ActionController::Base
  include Response
  include ExceptionHandler
  include Pundit

  before_action :authenticate_request
  attr_reader :current_user

  # :nocov:
  def self.add_common_params(api)
    api.param :form, :room_id, :integer, :required, "Room Id"
    api.param :form, :time_start, :DateTime, :required, "Time Start"
    api.param :form, :time_end, :DateTime, :required, "Time End"
  end
  # :nocov:

  private

  def authenticate_request
    @current_user = AuthorizeApiRequest.call(request.headers).result[:user]
  end
end
