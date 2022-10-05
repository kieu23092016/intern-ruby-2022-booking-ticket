class ChangeActivatedColumn < ActiveRecord::Migration[6.1]
  def change
    change_column :users, :activated, :integer
  end
end
