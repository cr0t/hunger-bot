class AddRoleIdToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :role_id, :integer
    add_foreign_key :users, :roles, column: :role_id
  end
end
