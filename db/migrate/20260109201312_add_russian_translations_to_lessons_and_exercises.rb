class AddRussianTranslationsToLessonsAndExercises < ActiveRecord::Migration[8.0]
  def change
    # Lesson translations
    add_column :lessons, :title_ru, :string
    add_column :lessons, :description_ru, :text

    # Exercise translations
    add_column :exercises, :title_ru, :string
    add_column :exercises, :description_ru, :text
    add_column :exercises, :instructions_ru, :text
    add_column :exercises, :hints_ru, :jsonb, default: []
  end
end
