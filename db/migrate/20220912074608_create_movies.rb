class CreateMovies < ActiveRecord::Migration[6.1]
  def change
    create_table :movies do |t|
      t.string :title
      t.text :description
      t.float :rating
      t.integer :duration_min
      t.datetime :release_time
      t.string :language
      t.string :director
      t.string :cast
      t.string :age_range

      t.timestamps
    end
  end
end
