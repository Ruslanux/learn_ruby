class CreateCodeSubmissions < ActiveRecord::Migration[8.0]
  def change
    create_table :code_submissions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :exercise, null: false, foreign_key: true
      t.text :code, null: false
      t.text :result
      t.boolean :passed, null: false, default: false
      t.float :execution_time

      t.timestamps
    end

    add_index :code_submissions, [ :user_id, :exercise_id, :created_at ], name: "index_submissions_on_user_exercise_time"
    add_index :code_submissions, :passed
  end
end
