class CreateAiRecommendations < ActiveRecord::Migration[8.0]
  def change
    create_table :ai_recommendations do |t|
      t.string :title
      t.text :description
      t.string :task_type
      t.date :suggested_date
      t.references :boat, null: false, foreign_key: true
      t.references :system_component, null: true, foreign_key: true

      t.timestamps
    end
  end
end
