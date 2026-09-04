import 'package:json_annotation/json_annotation.dart';
import 'learning_progress.dart';

part 'learning_report.g.dart';

enum ActionType {
  @JsonValue('practice')
  practice,
  @JsonValue('review')
  review,
  @JsonValue('advance')
  advance
}

@JsonSerializable(fieldRename: FieldRename.snake)
class LearningReport {
  final String childId;
  final String childName;
  @JsonKey(defaultValue: 'Science Lesson')
  final String lessonTitle;
  @JsonKey(defaultValue: 'Science')
  final String subject;
  @JsonKey(defaultValue: '')
  final String topic;
  @JsonKey(defaultValue: 0.0)
  final double overallMastery;
  @JsonKey(defaultValue: <ConceptMastery>[])
  final List<ConceptMastery> conceptBreakdown;
  @JsonKey(defaultValue: '')
  final String aiInsight;
  @JsonKey(defaultValue: <RecommendedAction>[])
  final List<RecommendedAction> recommendedActions;
  final SessionSummary? sessionSummary;
  final DateTime? generatedAt;

  const LearningReport({
    required this.childId,
    required this.childName,
    this.lessonTitle = 'Science Lesson',
    this.subject = 'Science',
    this.topic = '',
    this.overallMastery = 0.0,
    this.conceptBreakdown = const [],
    this.aiInsight = '',
    this.recommendedActions = const [],
    this.sessionSummary,
    this.generatedAt,
  });

  factory LearningReport.fromJson(Map<String, dynamic> json) => _$LearningReportFromJson(json);
  Map<String, dynamic> toJson() => _$LearningReportToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ConceptMastery {
  final String conceptId;
  final String conceptName;
  @JsonKey(defaultValue: 0.0)
  final double mastery;
  @JsonKey(defaultValue: MasteryTier.needsPractice)
  final MasteryTier tier;
  @JsonKey(defaultValue: 0)
  final int attempts;
  @JsonKey(defaultValue: 0.0)
  final double accuracy;

  const ConceptMastery({
    required this.conceptId,
    required this.conceptName,
    this.mastery = 0.0,
    this.tier = MasteryTier.needsPractice,
    this.attempts = 0,
    this.accuracy = 0.0,
  });

  factory ConceptMastery.fromJson(Map<String, dynamic> json) => _$ConceptMasteryFromJson(json);
  Map<String, dynamic> toJson() => _$ConceptMasteryToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class RecommendedAction {
  @JsonKey(defaultValue: ActionType.practice)
  final ActionType type;
  final String title;
  @JsonKey(defaultValue: '')
  final String description;
  @JsonKey(defaultValue: <String>[])
  final List<String> conceptIds;
  @JsonKey(defaultValue: 10)
  final int estimatedMinutes;

  const RecommendedAction({
    this.type = ActionType.practice,
    required this.title,
    this.description = '',
    this.conceptIds = const [],
    this.estimatedMinutes = 10,
  });

  factory RecommendedAction.fromJson(Map<String, dynamic> json) => _$RecommendedActionFromJson(json);
  Map<String, dynamic> toJson() => _$RecommendedActionToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class SessionSummary {
  @JsonKey(defaultValue: 0)
  final int totalSessions;
  @JsonKey(defaultValue: 0)
  final int totalTimeMinutes;
  @JsonKey(defaultValue: 0.0)
  final double averageScore;
  @JsonKey(defaultValue: 0)
  final int bestScore;
  @JsonKey(defaultValue: 0.0)
  final double improvementTrend;

  const SessionSummary({
    this.totalSessions = 0,
    this.totalTimeMinutes = 0,
    this.averageScore = 0.0,
    this.bestScore = 0,
    this.improvementTrend = 0.0,
  });

  factory SessionSummary.fromJson(Map<String, dynamic> json) => _$SessionSummaryFromJson(json);
  Map<String, dynamic> toJson() => _$SessionSummaryToJson(this);
}
