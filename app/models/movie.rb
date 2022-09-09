class Movie < ApplicationRecord
  has_many :comments, :show_times, dependent: :destroy
  belongs_to :category
end
