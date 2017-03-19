class Menu < ApplicationRecord
  self.table_name = 'menu'

  belongs_to :category
  belongs_to :provider, class_name: 'User'
end
