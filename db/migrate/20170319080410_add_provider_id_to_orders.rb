class AddProviderIdToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :menu, :provider_id, :integer
    add_foreign_key :menu, :users, column: :provider_id
  end
end
