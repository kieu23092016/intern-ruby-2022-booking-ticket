class ShowTime < ApplicationRecord
  has_many :seats, dependent: :destroy
  belongs_to :movie
  belongs_to :room
end
