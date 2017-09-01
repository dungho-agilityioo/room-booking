class ActsAsBookable::BookingPolicy < ApplicationPolicy

  def index?
    login?
  end

  def show?
    login?
  end

  def create?
    login?
  end

  # def update?
  #   @current_user.admin?
  # end

  def destroy?
    login?
  end

end
