class DeleteSeatShowtimeId < ActiveRecord::Migration[6.1]
  def change
    remove_foreign_key :tickets, column: :show_time_id
  end
end
