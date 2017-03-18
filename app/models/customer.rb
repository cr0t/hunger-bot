class Customer < ApplicationRecord
  has_many :orders
  has_many :telegram_messages

  def newbie?
    first_name.nil? || last_name.nil?
  end
end
