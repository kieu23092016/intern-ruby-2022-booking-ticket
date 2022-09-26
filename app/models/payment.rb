class Payment < ApplicationRecord
  has_many :tickets, dependent: :destroy
  belongs_to :user
  enum status: {pending: 1, approve: 2}
end
