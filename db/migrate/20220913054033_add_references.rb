class AddReferences < ActiveRecord::Migration[6.1]
  def change
    add_reference(:payments, :user, foreign_key: true)
    add_reference(:comments, :user, foreign_key: true)
    add_reference(:comments, :movie, foreign_key: true)
    add_reference(:show_times, :movie, foreign_key: true)
    add_reference(:tickets, :show_time, foreign_key: true)
    add_reference(:tickets, :payment, foreign_key: true)
    add_reference(:show_times, :room, foreign_key: true)
    add_reference(:rooms, :cinema, foreign_key: true)
    add_reference(:movies, :category, foreign_key: true)
  end
end
