class Cinema < ApplicationRecord
  has_many :rooms, dependent: :destroy

  class << self
    def get_info
      cinema_hash = Hash.new
      Cinema.all.find_each do |ci|
        cinema_hash[ci] = Hash.new
        rooms = ci.rooms
        rooms.each do |ro|
          cinema_hash[ci][ro] = Hash.new
          cinema_hash[ci][ro] = ro.show_times
        end
      end
      cinema_hash
    end

    def grouped_options
      all.map do |cinema|
        [cinema.name, cinema.rooms.pluck(:name, :id)]
      end
    end
  end
end
