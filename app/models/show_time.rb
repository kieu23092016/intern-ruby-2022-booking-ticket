class ShowTime < ApplicationRecord
  has_many :tickets, dependent: :destroy
  belongs_to :movie
  belongs_to :room
end
