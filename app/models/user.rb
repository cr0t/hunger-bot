class User < ApplicationRecord
  belongs_to :role

  after_create :set_role

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  scope :customers, -> { joins(:role).where(roles: { name: 'Customer' }) }
  scope :providers, -> { joins(:role).where(roles: { name: 'Provider' }) }
  scope :admins,    -> { joins(:role).where(roles: { name: 'Admin' }) }

  def display_name
    "#{name} <#{email}>"
  end

  def set_role
    update_attribute(:role, Role.where(name: 'Provider').first)
  end
end
