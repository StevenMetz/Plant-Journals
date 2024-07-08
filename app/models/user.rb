class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  include Devise::JWT::RevocationStrategies::JTIMatcher
  devise :database_authenticatable, :registerable, :trackable, :recoverable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: self
  has_one :plant_journal, dependent: :destroy
  has_one_attached :image
  has_many :plants
  has_many :shared_journals
  has_many :shared_plant_journals, through: :shared_journals, source: :plant_journal
end
