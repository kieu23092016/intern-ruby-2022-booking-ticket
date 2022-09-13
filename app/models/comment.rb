class Comment < ApplicationRecord
  belongs_to :user, :movie

  validates :content, length: {maximum: Settings.digits.length_cmt_max}
end
