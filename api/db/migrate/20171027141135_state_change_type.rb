class StateChangeType < ActiveRecord::Migration[5.0]
  def change
    change_column :bookings, :state, :string
  end
end
