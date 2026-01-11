class CreateExercises < ActiveRecord::Migration[8.0]
  def change
    create_table :exercises do |t|
      t.references :lesson, null: false, foreign_key: true
      t.string :title, null: false
      t.text :description
      t.text :instructions
      t.jsonb :hints, default: []
      t.text :starter_code
      t.text :solution_code
      t.text :test_code, null: false
      t.jsonb :topics, default: []
      t.integer :points, null: false, default: 10
      t.integer :position, null: false, default: 0

      t.timestamps
    end

    add_index :exercises, [ :lesson_id, :position ], unique: true
  end
end
