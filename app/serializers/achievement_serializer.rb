class AchievementSerializer < ApplicationSerializer
  def as_json
    case options[:variant]
    when :earned
      earned_json
    else
      full_json
    end
  end

  private

  def earned_json
    user_achievement = options[:user_achievement]

    {
      id: object.id,
      name: object.name,
      description: object.description,
      badge_icon: object.badge_icon,
      category: object.category,
      earned_at: user_achievement&.earned_at
    }
  end

  def full_json
    {
      id: object.id,
      name: object.name,
      description: object.description,
      badge_icon: object.badge_icon,
      category: object.category,
      earned: earned?,
      requirement_met: object.requirement_met?(current_user)
    }
  end

  def earned?
    return false unless current_user

    current_user.has_achievement?(object)
  end
end
