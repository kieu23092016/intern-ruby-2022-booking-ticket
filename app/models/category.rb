class Category < ApplicationRecord
  has_many :movies, dependent: :restrict_with_exception
end
