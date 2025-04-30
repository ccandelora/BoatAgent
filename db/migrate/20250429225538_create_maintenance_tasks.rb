class CreateMaintenanceTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :maintenance_tasks do |t|
      t.string :title
      t.text :description
      t.datetime :completed_at
      t.date :due_date
      t.decimal :cost
      t.integer :engine_hours
      t.text :notes
      t.references :boat, null: false, foreign_key: true
      t.references :system_component, null: true, foreign_key: true

      t.timestamps
    end
  end
end
