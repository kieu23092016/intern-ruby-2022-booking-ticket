class AddImgField < ActiveRecord::Migration[6.1]
  def change
    add_column :movies, :img_link, :string
  end
end
