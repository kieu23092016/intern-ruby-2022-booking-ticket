class Room < ApplicationRecord
  has_many :show_times, dependent: :destroy
  belongs_to :cinema

  delegate :name, to: :cinema, prefix: :cinema
end
