class Payment < ApplicationRecord
  has_many :tickets, dependent: destroy
  belongs_to :user
end
