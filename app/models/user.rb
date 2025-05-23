class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  devise :database_authenticatable, :registerable, :trackable, :recoverable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: self
  has_many :notifications, dependent: :destroy
  has_many :plant_journals, dependent: :destroy
  has_many :plants, dependent: :destroy
  has_many :shared_journals , dependent: :destroy
  has_many :shared_plant_journals, through: :shared_journals, source: :plant_journal ,dependent: :destroy
  has_many :feedbacks
  has_one_attached :image , dependent: :destroy
  has_one_attached :banner, dependent: :destroy
end
