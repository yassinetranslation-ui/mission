// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learning_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LearningReport _$LearningReportFromJson(Map<String, dynamic> json) =>
    LearningReport(
      childId: json['child_id'] as String,
      childName: json['child_name'] as String,
      lessonTitle: json['lesson_title'] as String? ?? 'Science Lesson',
      subject: json['subject'] as String? ?? 'Science',
      topic: json['topic'] as String? ?? '',
      overallMastery: (json['overall_mastery'] as num?)?.toDouble() ?? 0.0,
      conceptBreakdown: (json['concept_breakdown'] as List<dynamic>?)
              ?.map((e) => ConceptMastery.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      aiInsight: json['ai_insight'] as String? ?? '',
      recommendedActions: (json['recommended_actions'] as List<dynamic>?)
              ?.map(
                  (e) => RecommendedAction.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      sessionSummary: json['session_summary'] == null
          ? null
          : SessionSummary.fromJson(
              json['session_summary'] as Map<String, dynamic>),
      generatedAt: json['generated_at'] == null
          ? null
          : DateTime.parse(json['generated_at'] as String),
    );

Map<String, dynamic> _$LearningReportToJson(LearningReport instance) =>
    <String, dynamic>{
      'child_id': instance.childId,
      'child_name': instance.childName,
      'lesson_title': instance.lessonTitle,
      'subject': instance.subject,
      'topic': instance.topic,
      'overall_mastery': instance.overallMastery,
      'concept_breakdown': instance.conceptBreakdown,
      'ai_insight': instance.aiInsight,
      'recommended_actions': instance.recommendedActions,
      'session_summary': instance.sessionSummary,
      'generated_at': instance.generatedAt?.toIso8601String(),
    };

ConceptMastery _$ConceptMasteryFromJson(Map<String, dynamic> json) =>
    ConceptMastery(
      conceptId: json['concept_id'] as String,
      conceptName: json['concept_name'] as String,
      mastery: (json['mastery'] as num?)?.toDouble() ?? 0.0,
      tier: $enumDecodeNullable(_$MasteryTierEnumMap, json['tier']) ??
          MasteryTier.needsPractice,
      attempts: (json['attempts'] as num?)?.toInt() ?? 0,
      accuracy: (json['accuracy'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$ConceptMasteryToJson(ConceptMastery instance) =>
    <String, dynamic>{
      'concept_id': instance.conceptId,
      'concept_name': instance.conceptName,
      'mastery': instance.mastery,
      'tier': _$MasteryTierEnumMap[instance.tier]!,
      'attempts': instance.attempts,
      'accuracy': instance.accuracy,
    };

const _$MasteryTierEnumMap = {
  MasteryTier.needsPractice: 'needsPractice',
  MasteryTier.developing: 'developing',
  MasteryTier.good: 'good',
  MasteryTier.mastered: 'mastered',
};

RecommendedAction _$RecommendedActionFromJson(Map<String, dynamic> json) =>
    RecommendedAction(
      type: $enumDecodeNullable(_$ActionTypeEnumMap, json['type']) ??
          ActionType.practice,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      conceptIds: (json['concept_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      estimatedMinutes: (json['estimated_minutes'] as num?)?.toInt() ?? 10,
    );

Map<String, dynamic> _$RecommendedActionToJson(RecommendedAction instance) =>
    <String, dynamic>{
      'type': _$ActionTypeEnumMap[instance.type]!,
      'title': instance.title,
      'description': instance.description,
      'concept_ids': instance.conceptIds,
      'estimated_minutes': instance.estimatedMinutes,
    };

const _$ActionTypeEnumMap = {
  ActionType.practice: 'practice',
  ActionType.review: 'review',
  ActionType.advance: 'advance',
};

SessionSummary _$SessionSummaryFromJson(Map<String, dynamic> json) =>
    SessionSummary(
      totalSessions: (json['total_sessions'] as num?)?.toInt() ?? 0,
      totalTimeMinutes: (json['total_time_minutes'] as num?)?.toInt() ?? 0,
      averageScore: (json['average_score'] as num?)?.toDouble() ?? 0.0,
      bestScore: (json['best_score'] as num?)?.toInt() ?? 0,
      improvementTrend: (json['improvement_trend'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$SessionSummaryToJson(SessionSummary instance) =>
    <String, dynamic>{
      'total_sessions': instance.totalSessions,
      'total_time_minutes': instance.totalTimeMinutes,
      'average_score': instance.averageScore,
      'best_score': instance.bestScore,
      'improvement_trend': instance.improvementTrend,
    };
