class AddCoreTables < ActiveRecord::Migration[5.0]
  def self.up
    create_table :categories do |t|
      t.string :name, null: false
    end

    create_table :menu do |t|
      t.integer :category_id, null: false
      t.string :name, null: false
      t.decimal :price, default: 0, precision: 10, scale: 2
    end

    add_foreign_key :menu, :categories, column: :category_id

    create_table :roles do |t|
      t.string :name, null: false
    end

    create_table :orders do |t|
      t.integer :menu_id
      t.integer :quantity
      t.decimal :amount, default: 0, precision: 10, scale: 2
      t.string :address
      t.string :contacts
      t.integer :customer_id, null: false
      t.integer :provider_id, null: false
    end

    add_foreign_key :orders, :menu, column: :menu_id
    add_foreign_key :orders, :users, column: :customer_id
    add_foreign_key :orders, :users, column: :provider_id
  end

  def self.down
    drop_table :menu
    drop_table :categories
    drop_table :roles
    drop_table :orders
  end
end
