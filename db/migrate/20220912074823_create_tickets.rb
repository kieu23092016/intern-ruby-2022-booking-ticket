class CreateTickets < ActiveRecord::Migration[6.1]
  def change
    create_table :tickets do |t|
      t.integer :price
      t.integer :type
      t.string :seat_number
      t.boolean :status

      t.timestamps
    end
  end
end
