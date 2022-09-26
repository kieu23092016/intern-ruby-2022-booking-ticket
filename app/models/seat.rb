class Seat < ApplicationRecord
  has_one :ticket, dependent: :destroy
  belongs_to :show_time
end
