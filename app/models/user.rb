class User < ApplicationRecord
  belongs_to :role
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :validatable

  scope :customers, -> { joins(:role).where(roles: { name: 'Customer' }) }
  scope :providers, -> { joins(:role).where(roles: { name: 'Provider' }) }
  scope :admins,    -> { joins(:role).where(roles: { name: 'Admin' }) }

  def display_name
    "#{name} <#{email}>"
  end
end
