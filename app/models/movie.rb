class Movie < ApplicationRecord
  has_many :comments, dependent: :destroy
  has_many :show_times, dependent: :destroy
  belongs_to :category

  delegate :name, to: :category
end
