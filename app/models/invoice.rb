class Invoice < ApplicationRecord
  belongs_to :client
  belongs_to :provider
  has_many :order
end
