class Order < ApplicationRecord
  belongs_to :product
  belongs_to :client

  enum status: {
    dont_framed: "Не оформлен",
    processing: "На обработке",
    framed: "Оформлен",
    delivered: "Доставлен",
    canceled: "Отменен"
  }
  
  validates :count, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
