import 'package:dio/dio.dart';
import '../models/content_analysis.dart';
import '../models/game_specification.dart';
import '../models/game_session.dart';

class SubmitAnswerRequest {
  final String questionId;
  final String? conceptId;
  final dynamic answerGiven;
  final int responseTimeMs;

  SubmitAnswerRequest({
    required this.questionId,
    this.conceptId,
    required this.answerGiven,
    required this.responseTimeMs,
  });

  Map<String, dynamic> toJson() => {
        'question_id': questionId,
        if (conceptId != null) 'concept_id': conceptId,
        'answer_given': answerGiven,
        'response_time_ms': responseTimeMs,
      };
}

class AnswerResult {
  final bool isCorrect;
  final String explanation;
  final int xpEarned;
  final String? conceptId;

  const AnswerResult({
    required this.isCorrect,
    required this.explanation,
    required this.xpEarned,
    this.conceptId,
  });

  factory AnswerResult.fromJson(Map<String, dynamic> json) {
    return AnswerResult(
      isCorrect: (json['is_correct'] ?? json['isCorrect']) as bool,
      explanation: (json['explanation'] ?? '') as String,
      xpEarned: (json['xp_earned'] ?? json['xpEarned'] ?? 0) as int,
      conceptId: (json['concept_id'] ?? json['conceptId']) as String?,
    );
  }
}

class GameService {
  final Dio _dio;

  GameService(this._dio);

  Future<ContentAnalysis> analyzeLesson(String lessonId) async {
    final response = await _dio.post('/games/analyze/$lessonId');
    return ContentAnalysis.fromJson(response.data as Map<String, dynamic>);
  }

  Future<GameSpecification> generateGame(String lessonId, {String? childId, int durationMinutes = 10, String difficulty = 'medium'}) async {
    final response = await _dio.post('/games/generate/$lessonId', data: {
      'lesson_id': lessonId,
      'child_id': childId ?? '',
      'duration_minutes': durationMinutes,
      'difficulty': difficulty,
    });
    final data = response.data as Map<String, dynamic>;
    if (data['specification'] != null && data['specification'] is Map) {
      return GameSpecification.fromJson(data['specification'] as Map<String, dynamic>);
    }
    return GameSpecification.fromJson(data);
  }

  Future<GameSpecification> getGame(String gameId) async {
    final response = await _dio.get('/games/$gameId');
    final data = response.data as Map<String, dynamic>;
    if (data['specification'] != null && data['specification'] is Map) {
      return GameSpecification.fromJson(data['specification'] as Map<String, dynamic>);
    }
    return GameSpecification.fromJson(data);
  }

  Future<List<GameSpecification>> getGamesForChild(String childId) async {
    final response = await _dio.get('/games/child/$childId');
    if (response.data is Map && response.data['games'] != null) {
      final list = response.data['games'] as List;
      final results = <GameSpecification>[];
      for (final item in list) {
        if (item is Map<String, dynamic>) {
          if (item['specification'] != null && item['specification'] is Map) {
            results.add(GameSpecification.fromJson(item['specification'] as Map<String, dynamic>));
          }
        }
      }
      return results;
    }
    return [];
  }

  Future<GameSession> startSession(String gameId, String childId) async {
    final response = await _dio.post('/sessions/start', data: {
      'game_id': gameId,
      'child_id': childId,
    });
    return GameSession.fromJson(response.data as Map<String, dynamic>);
  }

  Future<AnswerResult> submitAnswer(String sessionId, SubmitAnswerRequest request) async {
    final response = await _dio.post('/sessions/$sessionId/answer', data: request.toJson());
    return AnswerResult.fromJson(response.data as Map<String, dynamic>);
  }

  Future<GameSession> completeSession(String sessionId) async {
    final response = await _dio.post('/sessions/$sessionId/complete');
    return GameSession.fromJson(response.data as Map<String, dynamic>);
  }
}
