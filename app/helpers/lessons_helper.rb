module LessonsHelper
  MODULE_KEYS = {
    1 => "basics",
    2 => "data",
    3 => "advanced",
    4 => "modern"
  }.freeze

  DIFFICULTY_COLORS = {
    "beginner" => "bg-green-100 text-green-800",
    "intermediate" => "bg-blue-100 text-blue-800",
    "advanced" => "bg-purple-100 text-purple-800",
    "modern" => "bg-red-100 text-red-800"
  }.freeze

  DIFFICULTY_BG = {
    "beginner" => "bg-green-50",
    "intermediate" => "bg-blue-50",
    "advanced" => "bg-purple-50",
    "modern" => "bg-red-50"
  }.freeze

  def module_name(number)
    key = MODULE_KEYS[number]
    key ? I18n.t("home.modules.#{key}") : I18n.t("lessons.module", number: number)
  end

  def module_description(number)
    key = MODULE_KEYS[number]
    key ? I18n.t("home.modules.#{key}_desc") : ""
  end

  def difficulty_badge(difficulty)
    color_class = DIFFICULTY_COLORS[difficulty] || "bg-gray-100 text-gray-800"
    label = I18n.t("lessons.difficulty.#{difficulty}", default: difficulty.capitalize)
    content_tag(:span, label, class: "px-2 py-1 text-xs font-medium rounded-full #{color_class}")
  end

  def difficulty_bg_class(difficulty)
    DIFFICULTY_BG[difficulty] || "bg-gray-50"
  end

  def progress_for_module(module_number, lessons, user_progress)
    return 0 unless user_progress.present?

    exercise_ids = lessons.flat_map { |l| l.exercises.pluck(:id) }
    return 0 if exercise_ids.empty?

    completed = exercise_ids.count { |id| user_progress[id]&.completed? }
    (completed.to_f / exercise_ids.size * 100).round
  end

  def progress_for_lesson(lesson, user_progress)
    return 0 unless user_progress.present?

    exercise_ids = lesson.exercises.pluck(:id)
    return 0 if exercise_ids.empty?

    completed = exercise_ids.count { |id| user_progress[id]&.completed? }
    (completed.to_f / exercise_ids.size * 100).round
  end

  def exercise_status_icon(exercise, user_progress)
    progress = user_progress[exercise.id]

    if progress.nil? || progress.not_started?
      content_tag(:span, "○", class: "text-gray-400 text-xl", title: "Not started")
    elsif progress.in_progress?
      content_tag(:span, "◐", class: "text-yellow-500 text-xl", title: "In progress")
    else
      content_tag(:span, "●", class: "text-green-500 text-xl", title: "Completed")
    end
  end

  def exercise_status_class(exercise, user_progress)
    progress = user_progress[exercise.id]

    if progress.nil? || progress.not_started?
      "border-gray-200 hover:border-gray-300"
    elsif progress.in_progress?
      "border-yellow-300 hover:border-yellow-400 bg-yellow-50"
    else
      "border-green-300 hover:border-green-400 bg-green-50"
    end
  end
end
