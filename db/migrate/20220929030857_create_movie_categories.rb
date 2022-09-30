class CreateMovieCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :movie_categories do |t|
      t.timestamps
    end

    add_reference(:movie_categories, :movie, foreign_key: true)
    add_reference(:movie_categories, :category, foreign_key: true)
  end
end
