class Api::V1::Admin::ReportsControllerPolicy < ApplicationPolicy

  def index?
    @current_user.admin?
  end

end
