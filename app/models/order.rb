class Order < ApplicationRecord
  belongs_to :menu
  belongs_to :customer
  belongs_to :provider, class_name: 'User'
end
