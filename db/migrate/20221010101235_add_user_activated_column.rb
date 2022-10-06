class AddUserActivatedColumn < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :activated, :integer
  end
end
