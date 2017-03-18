class CreateCustomers < ActiveRecord::Migration[5.0]
  def change
    create_table :customers do |t|
      t.integer :telegram_id, null: false
      t.string :first_name
      t.string :last_name
      t.string :phone_number
      t.string :last_address

      t.timestamps
    end

    add_index :customers, :telegram_id
  end
end
