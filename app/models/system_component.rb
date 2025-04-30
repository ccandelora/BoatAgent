class SystemComponent < ApplicationRecord
  has_many :maintenance_tasks, dependent: :nullify
  has_many :ai_recommendations, dependent: :nullify

  validates :name, presence: true, uniqueness: true
end
