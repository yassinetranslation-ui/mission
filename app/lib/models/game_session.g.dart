// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameSession _$GameSessionFromJson(Map<String, dynamic> json) => GameSession(
      id: json['id'] as String,
      gameId: json['gameId'] as String,
      childId: json['childId'] as String,
      score: (json['score'] as num).toInt(),
      xpEarned: (json['xpEarned'] as num).toInt(),
      completionPercentage: (json['completionPercentage'] as num).toDouble(),
      totalQuestions: (json['totalQuestions'] as num).toInt(),
      correctAnswers: (json['correctAnswers'] as num).toInt(),
      durationSeconds: (json['durationSeconds'] as num?)?.toInt(),
      status: $enumDecode(_$SessionStatusEnumMap, json['status']),
      startedAt: DateTime.parse(json['startedAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
    );

Map<String, dynamic> _$GameSessionToJson(GameSession instance) =>
    <String, dynamic>{
      'id': instance.id,
      'gameId': instance.gameId,
      'childId': instance.childId,
      'score': instance.score,
      'xpEarned': instance.xpEarned,
      'completionPercentage': instance.completionPercentage,
      'totalQuestions': instance.totalQuestions,
      'correctAnswers': instance.correctAnswers,
      'durationSeconds': instance.durationSeconds,
      'status': _$SessionStatusEnumMap[instance.status]!,
      'startedAt': instance.startedAt.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
    };

const _$SessionStatusEnumMap = {
  SessionStatus.inProgress: 'inProgress',
  SessionStatus.completed: 'completed',
  SessionStatus.abandoned: 'abandoned',
};

SessionAnswer _$SessionAnswerFromJson(Map<String, dynamic> json) =>
    SessionAnswer(
      id: json['id'] as String,
      sessionId: json['sessionId'] as String,
      questionId: json['questionId'] as String,
      conceptId: json['conceptId'] as String,
      answerGiven: json['answerGiven'],
      isCorrect: json['isCorrect'] as bool,
      responseTimeMs: (json['responseTimeMs'] as num).toInt(),
      attemptNumber: (json['attemptNumber'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$SessionAnswerToJson(SessionAnswer instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sessionId': instance.sessionId,
      'questionId': instance.questionId,
      'conceptId': instance.conceptId,
      'answerGiven': instance.answerGiven,
      'isCorrect': instance.isCorrect,
      'responseTimeMs': instance.responseTimeMs,
      'attemptNumber': instance.attemptNumber,
      'createdAt': instance.createdAt.toIso8601String(),
    };
