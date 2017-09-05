class AddScheduleToRoom < ActiveRecord::Migration[5.0]
  def change
    add_column :rooms, :schedule, :text
    add_column :rooms, :capacity, :integer
  end
end
