class Payment < ApplicationRecord
  has_many :tickets, dependent: :destroy
  belongs_to :user
  enum status: {pending: 1, approve: 2}

  scope :sort_list, ->{order created_at: :desc}
  delegate :user_name, to: :user
end
