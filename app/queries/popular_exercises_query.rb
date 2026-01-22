# frozen_string_literal: true

class PopularExercisesQuery < BaseQuery
  DEFAULT_LIMIT = 5

  def initialize(relation = default_relation, limit: DEFAULT_LIMIT)
    super(relation)
    @limit = limit
  end

  def call
    relation.joins(:code_submissions)
            .group("exercises.id")
            .order("COUNT(code_submissions.id) DESC")
            .limit(@limit)
            .select("exercises.*, COUNT(code_submissions.id) as submission_count")
  end

  private

  def default_relation
    Exercise.all
  end
end
