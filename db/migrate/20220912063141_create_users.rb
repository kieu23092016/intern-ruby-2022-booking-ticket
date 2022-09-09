class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :user_name
      t.string :email
      t.integer :phone
      t.datetime :date_birth
      t.boolean :sex

      t.timestamps
    end
  end
end
