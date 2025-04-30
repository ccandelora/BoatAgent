class AddTaskTypeToMaintenanceTasks < ActiveRecord::Migration[8.0]
  def change
    add_column :maintenance_tasks, :task_type, :string
  end
end
