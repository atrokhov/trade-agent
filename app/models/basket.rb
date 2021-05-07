class Basket < ApplicationRecord
  belongs_to :product
  belongs_to :agent
  belongs_to :client
end
