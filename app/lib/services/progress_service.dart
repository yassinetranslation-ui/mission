import 'package:dio/dio.dart';
import '../models/learning_progress.dart';
import '../models/game_specification.dart';
import '../models/learning_report.dart';

class ProgressService {
  final Dio _dio;

  ProgressService(this._dio);

  Future<ChildProgress> getChildProgress(String childId) async {
    final response = await _dio.get('/progress/child/$childId');
    return ChildProgress.fromJson(response.data as Map<String, dynamic>);
  }

  Future<List<LearningProgress>> getWeakConcepts(String childId) async {
    final response = await _dio.get('/progress/child/$childId/weak-concepts');
    final data = response.data;
    if (data is Map && data['concepts'] != null) {
      return (data['concepts'] as List)
          .map((e) => LearningProgress.fromJson(e as Map<String, dynamic>))
          .toList();
    } else if (data is List) {
      return data.map((e) => LearningProgress.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<GameSpecification> generatePractice(String childId, List<String> conceptIds) async {
    final response = await _dio.post('/progress/child/$childId/practice', data: {
      'child_id': childId,
      'concept_ids': conceptIds,
      'duration_minutes': 10,
    });
    final data = response.data as Map<String, dynamic>;
    if (data['specification'] != null && data['specification'] is Map) {
      return GameSpecification.fromJson(data['specification'] as Map<String, dynamic>);
    }
    return GameSpecification.fromJson(data);
  }

  Future<LearningReport> getLearningReport(String childId, {String? lessonId}) async {
    final path = lessonId != null
        ? '/progress/child/$childId/report/$lessonId'
        : '/progress/child/$childId/report';
    final response = await _dio.get(path);
    return LearningReport.fromJson(response.data as Map<String, dynamic>);
  }
}
