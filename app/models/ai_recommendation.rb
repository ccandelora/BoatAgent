class AiRecommendation < ApplicationRecord
  belongs_to :boat
  belongs_to :system_component, optional: true

  validates :title, presence: true
  validates :description, presence: true

  TASK_TYPES = [ "routine", "seasonal", "preventive", "repair", "upgrade" ].freeze

  validates :task_type, inclusion: { in: TASK_TYPES }, allow_nil: true

  scope :upcoming, -> { where("suggested_date >= ?", Date.today).order(suggested_date: :asc) }
  scope :by_type, ->(type) { where(task_type: type) }

  def convert_to_task!
    boat.maintenance_tasks.create(
      title: title,
      description: description,
      due_date: suggested_date,
      system_component: system_component
    )
  end
end
