class Waybill < ApplicationRecord
  belongs_to :provider
  belongs_to :manager, class_name: 'Staff', foreign_key: 'manager_id', optional: true
  belongs_to :deliveryman, class_name: 'Staff', foreign_key: 'deliveryman_id', optional: true
  has_many :invoice
end
