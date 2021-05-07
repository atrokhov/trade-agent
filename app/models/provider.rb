class Provider < ApplicationRecord
  belongs_to :user
  has_many :product

  has_one_attached :logo
  
  validates :name, length: { maximum: 255 }
  validates :description, length: { maximum: 1000 }
end
