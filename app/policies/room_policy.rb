class RoomPolicy < ApplicationPolicy

  def index?
    @user.admin? || @user.staff?
  end

  def create?
    @user.admin?
  end

  def update?
    @user.admin?
  end

  def destroy?
    @user.admin?
  end

end
