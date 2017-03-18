class Order < ApplicationRecord
  belongs_to :menu
  has_one :customer, class_name: 'User', foreign_key: 'customer_id'
  has_one :provider, class_name: 'User', foreign_key: 'provider_id'
end
