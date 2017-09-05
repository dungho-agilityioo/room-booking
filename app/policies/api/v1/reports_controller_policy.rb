class Api::V1::ReportsControllerPolicy < ApplicationPolicy

  def by_range_date?
    @current_user.admin?
  end

end
