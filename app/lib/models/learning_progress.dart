import 'package:json_annotation/json_annotation.dart';
import 'game_session.dart';

part 'learning_progress.g.dart';

enum MasteryTier {
  @JsonValue('needsPractice')
  needsPractice,
  @JsonValue('developing')
  developing,
  @JsonValue('good')
  good,
  @JsonValue('mastered')
  mastered
}

@JsonSerializable(fieldRename: FieldRename.snake)
class LearningProgress {
  final String? id;
  final String? childId;
  final String conceptId;
  final String conceptName;
  @JsonKey(defaultValue: 0)
  final int attempts;
  @JsonKey(defaultValue: 0)
  final int correctAnswers;
  @JsonKey(defaultValue: 0.0)
  final double accuracy;
  @JsonKey(defaultValue: 0.0)
  final double masteryScore;
  @JsonKey(defaultValue: MasteryTier.needsPractice)
  final MasteryTier masteryTier;
  final DateTime? lastAttemptAt;

  const LearningProgress({
    this.id,
    this.childId,
    required this.conceptId,
    required this.conceptName,
    this.attempts = 0,
    this.correctAnswers = 0,
    this.accuracy = 0.0,
    this.masteryScore = 0.0,
    this.masteryTier = MasteryTier.needsPractice,
    this.lastAttemptAt,
  });

  static MasteryTier fromScore(double score) {
    if (score < 40) return MasteryTier.needsPractice;
    if (score < 70) return MasteryTier.developing;
    if (score < 85) return MasteryTier.good;
    return MasteryTier.mastered;
  }

  factory LearningProgress.fromJson(Map<String, dynamic> json) => _$LearningProgressFromJson(json);
  Map<String, dynamic> toJson() => _$LearningProgressToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ChildProgress {
  final String childId;
  final String childName;
  @JsonKey(defaultValue: 0.0)
  final double overallMastery;
  @JsonKey(defaultValue: 0)
  final int totalXp;
  @JsonKey(defaultValue: 0)
  final int gamesPlayed;
  @JsonKey(defaultValue: 0)
  final int conceptsLearned;
  @JsonKey(defaultValue: <SubjectProgress>[])
  final List<SubjectProgress> progressBySubject;
  @JsonKey(defaultValue: <LearningProgress>[])
  final List<LearningProgress> weakConcepts;
  @JsonKey(defaultValue: <LearningProgress>[])
  final List<LearningProgress> strongConcepts;
  @JsonKey(defaultValue: <GameSession>[])
  final List<GameSession> recentSessions;

  const ChildProgress({
    required this.childId,
    required this.childName,
    this.overallMastery = 0.0,
    this.totalXp = 0,
    this.gamesPlayed = 0,
    this.conceptsLearned = 0,
    this.progressBySubject = const [],
    this.weakConcepts = const [],
    this.strongConcepts = const [],
    this.recentSessions = const [],
  });

  factory ChildProgress.fromJson(Map<String, dynamic> json) => _$ChildProgressFromJson(json);
  Map<String, dynamic> toJson() => _$ChildProgressToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class SubjectProgress {
  final String subject;
  @JsonKey(defaultValue: '')
  final String topic;
  @JsonKey(defaultValue: 0.0)
  final double mastery;
  @JsonKey(defaultValue: 0)
  final int conceptCount;

  const SubjectProgress({
    required this.subject,
    this.topic = '',
    this.mastery = 0.0,
    this.conceptCount = 0,
  });

  factory SubjectProgress.fromJson(Map<String, dynamic> json) => _$SubjectProgressFromJson(json);
  Map<String, dynamic> toJson() => _$SubjectProgressToJson(this);
}
