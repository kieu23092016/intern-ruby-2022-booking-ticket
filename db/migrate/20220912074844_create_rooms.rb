class CreateRooms < ActiveRecord::Migration[6.1]
  def change
    create_table :rooms do |t|
      t.integer :row
      t.integer :length

      t.timestamps
    end
  end
end
