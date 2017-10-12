class ProjectPolicy < ApplicationPolicy

  def index?
    login?
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

  def assign_user?
    @current_user.admin?
  end

end
