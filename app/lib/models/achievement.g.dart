// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'achievement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Achievement _$AchievementFromJson(Map<String, dynamic> json) => Achievement(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      category: $enumDecode(_$AchievementCategoryEnumMap, json['category']),
      criteria: json['criteria'] as Map<String, dynamic>,
      xpBonus: (json['xpBonus'] as num).toInt(),
    );

Map<String, dynamic> _$AchievementToJson(Achievement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'icon': instance.icon,
      'category': _$AchievementCategoryEnumMap[instance.category]!,
      'criteria': instance.criteria,
      'xpBonus': instance.xpBonus,
    };

const _$AchievementCategoryEnumMap = {
  AchievementCategory.milestone: 'milestone',
  AchievementCategory.streak: 'streak',
  AchievementCategory.mastery: 'mastery',
  AchievementCategory.exploration: 'exploration',
  AchievementCategory.special: 'special',
};

ChildAchievement _$ChildAchievementFromJson(Map<String, dynamic> json) =>
    ChildAchievement(
      id: json['id'] as String,
      childId: json['childId'] as String,
      achievementId: json['achievementId'] as String,
      achievement: json['achievement'] == null
          ? null
          : Achievement.fromJson(json['achievement'] as Map<String, dynamic>),
      earnedAt: DateTime.parse(json['earnedAt'] as String),
    );

Map<String, dynamic> _$ChildAchievementToJson(ChildAchievement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'childId': instance.childId,
      'achievementId': instance.achievementId,
      'achievement': instance.achievement,
      'earnedAt': instance.earnedAt.toIso8601String(),
    };
