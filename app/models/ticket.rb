class Ticket < ApplicationRecord
  belongs_to :payment, :show_time
end
