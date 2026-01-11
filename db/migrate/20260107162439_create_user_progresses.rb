class CreateUserProgresses < ActiveRecord::Migration[8.0]
  def change
    create_table :user_progresses do |t|
      t.references :user, null: false, foreign_key: true
      t.references :exercise, null: false, foreign_key: true
      t.integer :status, null: false, default: 0
      t.integer :attempts, null: false, default: 0
      t.text :last_code
      t.datetime :completed_at
      t.integer :points_earned, null: false, default: 0

      t.timestamps
    end

    add_index :user_progresses, [ :user_id, :exercise_id ], unique: true
  end
end
