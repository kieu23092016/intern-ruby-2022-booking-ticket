class CreatePayments < ActiveRecord::Migration[6.1]
  def change
    create_table :payments do |t|
      t.integer :status
      t.datetime :payment_time 
      t.integer :total_cost

      t.timestamps
    end
  end
end
