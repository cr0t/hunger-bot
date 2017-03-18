class Order < ApplicationRecord
  belongs_to :menu
  belongs_to :customer, class_name: 'User'
  belongs_to :provider, class_name: 'User'
end
