class UpdateSeatReference < ActiveRecord::Migration[6.1]
  def change
    add_reference :seats, :show_time, foreign_key: true
    add_reference :tickets, :seat, foreign_key: true
  end
end
