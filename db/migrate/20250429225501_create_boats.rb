class CreateBoats < ActiveRecord::Migration[8.0]
  def change
    create_table :boats do |t|
      t.string :name
      t.string :make
      t.string :model
      t.integer :year
      t.string :engine_type
      t.string :location
      t.integer :hours
      t.text :description
      t.references :user, null: true

      t.timestamps
    end
  end
end
