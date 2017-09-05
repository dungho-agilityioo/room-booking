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

  def search?
    login?
  end

  def get_booked?
    login?
  end

  def destroy?
    login?
  end

end
