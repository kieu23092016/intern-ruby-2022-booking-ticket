class DropColumn < ActiveRecord::Migration[6.1]
  def change
    remove_column :movies, :img_link
  end
end
