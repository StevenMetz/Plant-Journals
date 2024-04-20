class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  include Devise::JWT::RevocationStrategies::JTIMatcher
  devise :database_authenticatable, :registerable, :trackable, :recoverable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: self
  has_one :plant_journal
  has_many :plants
end
