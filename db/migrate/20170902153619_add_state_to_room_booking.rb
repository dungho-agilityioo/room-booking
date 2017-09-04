class AddStateToRoomBooking < ActiveRecord::Migration[5.0]
  def change
    add_column :acts_as_bookable_bookings, :daily, :bool, default: false
    add_column :acts_as_bookable_bookings, :generate_for_id, :integer
  end
end
