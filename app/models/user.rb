class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtBlacklist

  validates_presence_of     :username # required
  validates_uniqueness_of   :username # required    
  validates_presence_of     :password, if: :password_required? # recommended
  validates_confirmation_of :password, if: :password_required? # recommended
  validates_length_of       :password, within: password_length, allow_blank: true # recommended

  def email_required?
    false
  end

  def email_changed?
    false
  end

  enum role: {
    admin: "Администратор",
    moderator: "Модератор",
    client: "Клиент",
    provider: "Поставщик",
    manager: "Менеджер",
    courier: "Курьер",
    trade_agent: "Торговый агент"
  }
end
