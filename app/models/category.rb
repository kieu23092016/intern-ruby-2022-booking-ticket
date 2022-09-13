class Category < ApplicationRecord
  has_many :movies, dependent: restrict
end
