class CreateLessons < ActiveRecord::Migration[8.0]
  def change
    create_table :lessons do |t|
      t.string :title, null: false
      t.text :description
      t.integer :module_number, null: false
      t.integer :position, null: false, default: 0
      t.integer :difficulty, null: false, default: 0
      t.string :ruby_version, null: false, default: "3.4"

      t.timestamps
    end

    add_index :lessons, :module_number
    add_index :lessons, [ :module_number, :position ], unique: true
  end
end
