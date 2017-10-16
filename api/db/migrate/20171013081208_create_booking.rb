class CreateBooking < ActiveRecord::Migration[5.0]
  def change
    create_table :bookings do |t|
      t.references :room, index: {name: "index_room_booking"}
      t.references :user, index: {name: "index_user_booking"}
      t.string :title
      t.integer :state, default: 0, index: {name: "index_state_booking"}
      t.boolean :daily, default: false
      t.integer :booking_ref_id
      t.datetime :start_date
      t.datetime :end_date
      t.text :description
      t.timestamps
    end
  end
end
