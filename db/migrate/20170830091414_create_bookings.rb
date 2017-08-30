class CreateBookings < ActiveRecord::Migration[5.0]
  def change
    create_table :bookings do |t|
      t.integer :user_id
      t.integer :project_id
      t.integer :booking_type
      t.text :reason
      t.date :start_date
      t.time :start_hour
      t.date :end_date
      t.time :end_hour

      t.timestamps
    end
  end
end
