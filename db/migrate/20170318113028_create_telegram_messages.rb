class CreateTelegramMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :telegram_messages do |t|
      t.references :customer, foreign_key: true, null: false
      t.json :raw
      t.integer :telegram_from_id, null: false
      t.text :text

      t.timestamps
    end

    add_index :telegram_messages, :telegram_from_id
  end
end
