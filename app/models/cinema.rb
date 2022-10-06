class Cinema < ApplicationRecord
  has_many :rooms, dependent: :destroy

  class << self
    def grouped_options
      all.map do |cinema|
        [cinema.name, cinema.rooms.pluck(:name, :id)]
      end
    end
  end
end
