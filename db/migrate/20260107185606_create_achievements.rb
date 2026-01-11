class CreateAchievements < ActiveRecord::Migration[8.0]
  def change
    create_table :achievements do |t|
      t.string :name, null: false
      t.string :description, null: false
      t.string :badge_icon, null: false
      t.integer :category, null: false, default: 0
      t.integer :points_required, default: 0
      t.integer :exercises_required, default: 0
      t.integer :streak_required, default: 0

      t.timestamps
    end

    add_index :achievements, :category
    add_index :achievements, :name, unique: true
  end
end
