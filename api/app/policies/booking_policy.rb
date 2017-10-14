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
    login?
  end

  def room_booked?
    login?
  end

  def destroy?
    login?
  end

end
