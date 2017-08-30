class RoomPolicy < ApplicationPolicy

  def index?
    @current_user.admin? || @current_user.staff?
  end

  def create?
    @current_user.admin?
  end

  def update?
    @current_user.admin?
  end

  def destroy?
    @current_user.admin?
  end

end
