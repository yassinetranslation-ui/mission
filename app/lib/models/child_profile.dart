import 'package:json_annotation/json_annotation.dart';

part 'child_profile.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ChildProfile {
  final String id;
  final String parentId;
  final String name;
  final int age;
  final String? avatar;
  final String? preferredLanguage;
  final String? gradeLevel;
  @JsonKey(defaultValue: <String>[])
  final List<String> preferredSubjects;
  @JsonKey(defaultValue: 0)
  final int xpTotal;
  @JsonKey(defaultValue: 1)
  final int currentLevel;
  @JsonKey(defaultValue: 0)
  final int currentStreak;
  final DateTime? lastActivityDate;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const ChildProfile({
    required this.id,
    required this.parentId,
    required this.name,
    required this.age,
    this.avatar,
    this.preferredLanguage,
    this.gradeLevel,
    this.preferredSubjects = const [],
    this.xpTotal = 0,
    this.currentLevel = 1,
    this.currentStreak = 0,
    this.lastActivityDate,
    required this.createdAt,
    this.updatedAt,
  });

  int get xpForNextLevel => currentLevel * 1000;
  bool get streakIsActive {
    if (lastActivityDate == null) return false;
    final now = DateTime.now();
    final difference = now.difference(lastActivityDate!).inDays;
    return difference <= 1;
  }

  factory ChildProfile.fromJson(Map<String, dynamic> json) => _$ChildProfileFromJson(json);
  Map<String, dynamic> toJson() => _$ChildProfileToJson(this);
}
