import 'package:json_annotation/json_annotation.dart';

part 'content_analysis.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ContentAnalysis {
  final String id;
  final String lessonId;
  final String? subject;
  final String? topic;
  final String? language;
  final String? estimatedGrade;
  final String? difficulty;
  final String? summary;
  @JsonKey(defaultValue: <String, dynamic>{})
  final Map<String, dynamic> concepts;
  @JsonKey(defaultValue: <dynamic>[])
  final List<dynamic> learningObjectives;
  @JsonKey(defaultValue: <dynamic>[])
  final List<dynamic> importantFacts;
  @JsonKey(defaultValue: <String, dynamic>{})
  final Map<String, dynamic> terminology;
  @JsonKey(defaultValue: <dynamic>[])
  final List<dynamic> potentialQuestions;
  final String? promptVersion;
  final int? inputTokens;
  final int? outputTokens;
  final double? estimatedCost;
  final DateTime createdAt;

  const ContentAnalysis({
    required this.id,
    required this.lessonId,
    this.subject,
    this.topic,
    this.language,
    this.estimatedGrade,
    this.difficulty,
    this.summary,
    this.concepts = const {},
    this.learningObjectives = const [],
    this.importantFacts = const [],
    this.terminology = const {},
    this.potentialQuestions = const [],
    this.promptVersion,
    this.inputTokens,
    this.outputTokens,
    this.estimatedCost,
    required this.createdAt,
  });

  factory ContentAnalysis.fromJson(Map<String, dynamic> json) => _$ContentAnalysisFromJson(json);
  Map<String, dynamic> toJson() => _$ContentAnalysisToJson(this);
}
