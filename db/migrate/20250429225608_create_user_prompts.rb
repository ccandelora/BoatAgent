class CreateUserPrompts < ActiveRecord::Migration[8.0]
  def change
    create_table :user_prompts do |t|
      t.text :content
      t.text :response
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
