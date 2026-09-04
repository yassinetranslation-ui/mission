import 'package:json_annotation/json_annotation.dart';

part 'achievement.g.dart';

enum AchievementCategory { milestone, streak, mastery, exploration, special }

@JsonSerializable()
class Achievement {
  final String id;
  final String name;
  final String description;
  final String icon;
  final AchievementCategory category;
  final Map<String, dynamic> criteria;
  final int xpBonus;

  const Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.category,
    required this.criteria,
    required this.xpBonus,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) => _$AchievementFromJson(json);
  Map<String, dynamic> toJson() => _$AchievementToJson(this);

  static const List<Achievement> defaultAchievements = [
    Achievement(
      id: 'firstMission',
      name: 'First Mission',
      description: 'Complete your first learning mission',
      icon: '🚀',
      category: AchievementCategory.milestone,
      criteria: {'missionsCompleted': 1},
      xpBonus: 100,
    ),
    Achievement(
      id: 'scienceExplorer',
      name: 'Science Explorer',
      description: 'Complete 5 science missions',
      icon: '🔬',
      category: AchievementCategory.exploration,
      criteria: {'subject': 'science', 'missionsCompleted': 5},
      xpBonus: 250,
    ),
    Achievement(
      id: 'perfectScore',
      name: 'Perfect Score',
      description: 'Get 100% on any mission',
      icon: '⭐',
      category: AchievementCategory.mastery,
      criteria: {'score': 100},
      xpBonus: 200,
    ),
    Achievement(
      id: 'streak7Days',
      name: 'Week Warrior',
      description: 'Maintain a 7-day learning streak',
      icon: '🔥',
      category: AchievementCategory.streak,
      criteria: {'streakDays': 7},
      xpBonus: 500,
    ),
    Achievement(
      id: 'conceptMaster',
      name: 'Concept Master',
      description: 'Master 10 different concepts',
      icon: '🧠',
      category: AchievementCategory.mastery,
      criteria: {'masteredConcepts': 10},
      xpBonus: 400,
    ),
    Achievement(
      id: 'bossSlayer',
      name: 'Boss Slayer',
      description: 'Defeat your first boss',
      icon: '⚔️',
      category: AchievementCategory.milestone,
      criteria: {'bossesDefeated': 1},
      xpBonus: 300,
    ),
    Achievement(
      id: 'streak30Days',
      name: 'Monthly Master',
      description: 'Maintain a 30-day learning streak',
      icon: '🏆',
      category: AchievementCategory.streak,
      criteria: {'streakDays': 30},
      xpBonus: 2000,
    ),
    Achievement(
      id: 'mathWizard',
      name: 'Math Wizard',
      description: 'Complete 10 math missions',
      icon: '📐',
      category: AchievementCategory.exploration,
      criteria: {'subject': 'math', 'missionsCompleted': 10},
      xpBonus: 500,
    ),
    Achievement(
      id: 'speedDemon',
      name: 'Speed Demon',
      description: 'Complete a mission in under 2 minutes with >80% accuracy',
      icon: '⚡',
      category: AchievementCategory.special,
      criteria: {'durationSecondsMax': 120, 'minScore': 80},
      xpBonus: 350,
    ),
    Achievement(
      id: 'persistent',
      name: 'Persistent Learner',
      description: 'Retry a failed mission and get >80%',
      icon: '💪',
      category: AchievementCategory.special,
      criteria: {'retrySuccess': true},
      xpBonus: 300,
    ),
  ];
}

@JsonSerializable()
class ChildAchievement {
  final String id;
  final String childId;
  final String achievementId;
  final Achievement? achievement;
  final DateTime earnedAt;

  const ChildAchievement({
    required this.id,
    required this.childId,
    required this.achievementId,
    this.achievement,
    required this.earnedAt,
  });

  factory ChildAchievement.fromJson(Map<String, dynamic> json) => _$ChildAchievementFromJson(json);
  Map<String, dynamic> toJson() => _$ChildAchievementToJson(this);
}
