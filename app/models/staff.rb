class Staff < ApplicationRecord
  belongs_to :provider
  belongs_to :user

  has_one_attached :avatar

  enum role: {
    manager: "Менеджер",
    courier: "Курьер",
    trade_agent: "Торговый агент"
  }
end
