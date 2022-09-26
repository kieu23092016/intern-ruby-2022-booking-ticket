class Ticket < ApplicationRecord
  belongs_to :payment, optional: true
  belongs_to :seat
end
