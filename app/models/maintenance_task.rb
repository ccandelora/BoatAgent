class MaintenanceTask < ApplicationRecord
  belongs_to :boat
  belongs_to :system_component, optional: true

  has_one_attached :photo

  TASK_TYPES = [ "routine", "seasonal", "preventive", "repair", "upgrade" ].freeze

  validates :title, presence: true
  validates :cost, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :engine_hours, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  validates :task_type, inclusion: { in: TASK_TYPES }, allow_nil: true

  scope :completed, -> { where.not(completed_at: nil) }
  scope :pending, -> { where(completed_at: nil) }
  scope :upcoming, -> { pending.where("due_date >= ?", Date.today).order(due_date: :asc) }
  scope :overdue, -> { pending.where("due_date < ?", Date.today).order(due_date: :asc) }
  scope :by_type, ->(type) { where(task_type: type) }

  def completed?
    completed_at.present?
  end

  def complete!
    update(completed_at: Time.current)
  end

  def uncomplete!
    update(completed_at: nil)
  end
end
