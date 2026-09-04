// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'child_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChildProfile _$ChildProfileFromJson(Map<String, dynamic> json) => ChildProfile(
      id: json['id'] as String,
      parentId: json['parent_id'] as String,
      name: json['name'] as String,
      age: (json['age'] as num).toInt(),
      avatar: json['avatar'] as String?,
      preferredLanguage: json['preferred_language'] as String?,
      gradeLevel: json['grade_level'] as String?,
      preferredSubjects: (json['preferred_subjects'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      xpTotal: (json['xp_total'] as num?)?.toInt() ?? 0,
      currentLevel: (json['current_level'] as num?)?.toInt() ?? 1,
      currentStreak: (json['current_streak'] as num?)?.toInt() ?? 0,
      lastActivityDate: json['last_activity_date'] == null
          ? null
          : DateTime.parse(json['last_activity_date'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$ChildProfileToJson(ChildProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'parent_id': instance.parentId,
      'name': instance.name,
      'age': instance.age,
      'avatar': instance.avatar,
      'preferred_language': instance.preferredLanguage,
      'grade_level': instance.gradeLevel,
      'preferred_subjects': instance.preferredSubjects,
      'xp_total': instance.xpTotal,
      'current_level': instance.currentLevel,
      'current_streak': instance.currentStreak,
      'last_activity_date': instance.lastActivityDate?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
