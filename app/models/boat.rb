class Boat < ApplicationRecord
  belongs_to :user

  has_many :maintenance_tasks, dependent: :destroy
  has_many :ai_recommendations, dependent: :destroy

  validates :name, presence: true
  validates :make, presence: true
  validates :model, presence: true
  validates :year, presence: true, numericality: { only_integer: true, greater_than: 1900, less_than_or_equal_to: -> { Time.current.year + 1 } }
  validates :hours, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
end
