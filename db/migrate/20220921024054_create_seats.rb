class CreateSeats < ActiveRecord::Migration[6.1]
  def change
    create_table :seats do |t|
      t.string :seat_number
      t.integer :status
      t.integer :seat_type

      t.timestamps
    end
  end
end
