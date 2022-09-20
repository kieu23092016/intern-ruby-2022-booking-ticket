class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :movie

  validates :content, length: {maximum: Settings.digits.length_cmt_max}
end
