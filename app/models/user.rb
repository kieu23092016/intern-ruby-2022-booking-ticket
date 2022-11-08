class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :lockable,
         :recoverable, :rememberable, :validatable
  attr_accessor :remember_token, :activation_token

  before_save :downcase_email

  has_many :comments, dependent: :destroy
  has_many :payments, dependent: :destroy

  enum sex: {Female: 0, Male: 1}
  enum activated: {Inactivated: 0, Activated: 1}

  validates :user_name, presence: true,
            length: {maximum: Settings.digits.length_name_max_50}

  validates :email, presence: true,
            length: {maximum: Settings.digits.length_email_max_255},
            format: {with: Settings.regex.email}

  validates :password, presence: true,
            length: {minimum: Settings.digits.length_password_min_6},
            allow_nil: true

  validates :phone, presence: true,
            length: {is: Settings.digits.length_phone_number},
            format: {with: Settings.regex.phone}

  scope :sort_list, ->{order :user_name}

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end

      BCrypt::Password.create(string, cost: cost)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

  def authenticated? attribute, token
    digest = send("#{attribute}_digest")
    return false if digest.nil?

    BCrypt::Password.new(digest).is_password?(token)
  end

  def activate
    update_columns(activated: 1)
  end

  def inactivate
    update_columns(activated: 0)
  end

  def send_noti_booking_email
    UserMailer.ticket_payment(self).deliver_now
  end

  private

  def downcase_email
    self.email = email.downcase
  end
end
