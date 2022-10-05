class User < ApplicationRecord
  has_many :comments, dependent: :destroy
  has_many :payments, dependent: :destroy

  enum sex: {female: 0, male: 1}

  validates :user_name, presence: true,
            length: {maximum: Settings.digits.length_name_max_50}

  validates :email, presence: true,
            length: {maximum: Settings.digits.length_email_max_255},
            format: {with: Settings.regex.email},
            uniqueness: true

  validates :password, presence: true,
            length: {minimum: Settings.digits.length_password_min_6},
            allow_nil: true

  validates :phone, presence: true,
          length: {is: Settings.digits.length_phone_number},
          format: {with: Settings.regex.phone},
          uniqueness: true

  has_secure_password

  scope :sort_list, ->{order :user_name}
  scope :filter_by_admin_role, ->{where admin: true}
end
