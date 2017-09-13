class Api::V1::ReportsControllerPolicy < ApplicationPolicy

  def index?
    @current_user.admin?
  end

end
