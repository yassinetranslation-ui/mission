import 'package:json_annotation/json_annotation.dart';

part 'game_session.g.dart';

enum SessionStatus { inProgress, completed, abandoned }

@JsonSerializable()
class GameSession {
  final String id;
  final String gameId;
  final String childId;
  final int score;
  final int xpEarned;
  final double completionPercentage;
  final int totalQuestions;
  final int correctAnswers;
  final int? durationSeconds;
  final SessionStatus status;
  final DateTime startedAt;
  final DateTime? completedAt;

  const GameSession({
    required this.id,
    required this.gameId,
    required this.childId,
    required this.score,
    required this.xpEarned,
    required this.completionPercentage,
    required this.totalQuestions,
    required this.correctAnswers,
    this.durationSeconds,
    required this.status,
    required this.startedAt,
    this.completedAt,
  });

  factory GameSession.fromJson(Map<String, dynamic> json) => _$GameSessionFromJson(json);
  Map<String, dynamic> toJson() => _$GameSessionToJson(this);
}

@JsonSerializable()
class SessionAnswer {
  final String id;
  final String sessionId;
  final String questionId;
  final String conceptId;
  final dynamic answerGiven;
  final bool isCorrect;
  final int responseTimeMs;
  final int attemptNumber;
  final DateTime createdAt;

  const SessionAnswer({
    required this.id,
    required this.sessionId,
    required this.questionId,
    required this.conceptId,
    required this.answerGiven,
    required this.isCorrect,
    required this.responseTimeMs,
    required this.attemptNumber,
    required this.createdAt,
  });

  factory SessionAnswer.fromJson(Map<String, dynamic> json) => _$SessionAnswerFromJson(json);
  Map<String, dynamic> toJson() => _$SessionAnswerToJson(this);
}
