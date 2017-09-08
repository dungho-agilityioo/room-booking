class ApplicationController < ActionController::Base
  include Response
  include ExceptionHandler
  include Pundit

  before_action :authenticate_request
  attr_reader :current_user

  class << self
    Swagger::Docs::Generator::set_real_methods

    def inherited(subclass)
      super
      subclass.class_eval do
        setup_basic_api_documentation
      end
    end

    def add_common_params(api)
      api.param :form, :room_id, :integer, :required, "Room Id"
      api.param :form, :time_start, :DateTime, :required, "Time Start"
      api.param :form, :time_end, :DateTime, :required, "Time End"
    end

    private
    def setup_basic_api_documentation
      [:index, :show, :create, :update, :destroy, :search, :room_booked, :by_range_date, :by_project, :projects].each do |api_action|
        swagger_api api_action do
          param :header, 'Authorization', :string, :required, 'Authentication token'
        end
      end
    end
  end

  private

  def authenticate_request
    @current_user = AuthorizeApiRequest.call(request.headers).result[:user]
  end
end
