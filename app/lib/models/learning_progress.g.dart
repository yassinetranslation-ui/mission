// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learning_progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LearningProgress _$LearningProgressFromJson(Map<String, dynamic> json) =>
    LearningProgress(
      id: json['id'] as String?,
      childId: json['child_id'] as String?,
      conceptId: json['concept_id'] as String,
      conceptName: json['concept_name'] as String,
      attempts: (json['attempts'] as num?)?.toInt() ?? 0,
      correctAnswers: (json['correct_answers'] as num?)?.toInt() ?? 0,
      accuracy: (json['accuracy'] as num?)?.toDouble() ?? 0.0,
      masteryScore: (json['mastery_score'] as num?)?.toDouble() ?? 0.0,
      masteryTier:
          $enumDecodeNullable(_$MasteryTierEnumMap, json['mastery_tier']) ??
              MasteryTier.needsPractice,
      lastAttemptAt: json['last_attempt_at'] == null
          ? null
          : DateTime.parse(json['last_attempt_at'] as String),
    );

Map<String, dynamic> _$LearningProgressToJson(LearningProgress instance) =>
    <String, dynamic>{
      'id': instance.id,
      'child_id': instance.childId,
      'concept_id': instance.conceptId,
      'concept_name': instance.conceptName,
      'attempts': instance.attempts,
      'correct_answers': instance.correctAnswers,
      'accuracy': instance.accuracy,
      'mastery_score': instance.masteryScore,
      'mastery_tier': _$MasteryTierEnumMap[instance.masteryTier]!,
      'last_attempt_at': instance.lastAttemptAt?.toIso8601String(),
    };

const _$MasteryTierEnumMap = {
  MasteryTier.needsPractice: 'needsPractice',
  MasteryTier.developing: 'developing',
  MasteryTier.good: 'good',
  MasteryTier.mastered: 'mastered',
};

ChildProgress _$ChildProgressFromJson(Map<String, dynamic> json) =>
    ChildProgress(
      childId: json['child_id'] as String,
      childName: json['child_name'] as String,
      overallMastery: (json['overall_mastery'] as num?)?.toDouble() ?? 0.0,
      totalXp: (json['total_xp'] as num?)?.toInt() ?? 0,
      gamesPlayed: (json['games_played'] as num?)?.toInt() ?? 0,
      conceptsLearned: (json['concepts_learned'] as num?)?.toInt() ?? 0,
      progressBySubject: (json['progress_by_subject'] as List<dynamic>?)
              ?.map((e) => SubjectProgress.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      weakConcepts: (json['weak_concepts'] as List<dynamic>?)
              ?.map((e) => LearningProgress.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      strongConcepts: (json['strong_concepts'] as List<dynamic>?)
              ?.map((e) => LearningProgress.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      recentSessions: (json['recent_sessions'] as List<dynamic>?)
              ?.map((e) => GameSession.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$ChildProgressToJson(ChildProgress instance) =>
    <String, dynamic>{
      'child_id': instance.childId,
      'child_name': instance.childName,
      'overall_mastery': instance.overallMastery,
      'total_xp': instance.totalXp,
      'games_played': instance.gamesPlayed,
      'concepts_learned': instance.conceptsLearned,
      'progress_by_subject': instance.progressBySubject,
      'weak_concepts': instance.weakConcepts,
      'strong_concepts': instance.strongConcepts,
      'recent_sessions': instance.recentSessions,
    };

SubjectProgress _$SubjectProgressFromJson(Map<String, dynamic> json) =>
    SubjectProgress(
      subject: json['subject'] as String,
      topic: json['topic'] as String? ?? '',
      mastery: (json['mastery'] as num?)?.toDouble() ?? 0.0,
      conceptCount: (json['concept_count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$SubjectProgressToJson(SubjectProgress instance) =>
    <String, dynamic>{
      'subject': instance.subject,
      'topic': instance.topic,
      'mastery': instance.mastery,
      'concept_count': instance.conceptCount,
    };
