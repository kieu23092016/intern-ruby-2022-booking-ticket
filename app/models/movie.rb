class Movie < ApplicationRecord
  MOVIE_ATTRS = %i(title description rating img_link
                   duration_min release_time language
                   director cast age_range category_id).freeze

  has_many :comments, dependent: :destroy
  has_many :show_times, dependent: :destroy
  belongs_to :category

  validates :title, presence: true
  validates :release_time, presence: true

  delegate :name, to: :category
  scope :sort_list, ->{order :release_time}
end
