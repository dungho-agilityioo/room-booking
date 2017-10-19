class BookingPolicy < ApplicationPolicy

  def index?
    login?
  end

  def show?
    true
  end

  def create?
    login?
  end

  def update?
    @current_user.admin? || (@current_user.staff? && (@current_user.id == @record.user_id))
  end

  def destroy?
    login?
  end

end
