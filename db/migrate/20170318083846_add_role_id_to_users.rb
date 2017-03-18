class AddRoleIdToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :role_id, :integer
    User.all.each do |user|
      user.update_attribute(:role_id, Role.where(name: 'Customer').first.id)
    end
    add_foreign_key :users, :roles, column: :role_id
  end
end
