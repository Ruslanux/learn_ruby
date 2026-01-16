class AddSolutionViewedToUserProgress < ActiveRecord::Migration[8.0]
  def change
    add_column :user_progresses, :solution_viewed, :boolean, default: false, null: false
  end
end
