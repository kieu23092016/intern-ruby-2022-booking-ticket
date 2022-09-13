class Room < ApplicationRecord
  has_many :show_times, dependent: destroy
  belongs_to :cinema
end
