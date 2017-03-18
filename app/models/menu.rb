class Menu < ApplicationRecord
  self.table_name = 'menu'

  belongs_to :category
end
