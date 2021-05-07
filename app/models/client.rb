class Client < ApplicationRecord
  belongs_to :user
  has_many :order

  has_one_attached :avatar
  has_one_attached :patent
  has_one_attached :passport
  has_one_attached :certificate

  enum client_type: {
    private_person: "Частное лицо",
    store_point: "Торговая точка"
  }
end
