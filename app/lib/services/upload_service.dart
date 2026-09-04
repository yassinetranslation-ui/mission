import 'dart:io';
import 'package:dio/dio.dart';
import '../models/lesson.dart';
import '../models/content_analysis.dart';

class UploadResult {
  final String lessonId;
  final String status;
  final String fileType;
  final String title;

  UploadResult({
    required this.lessonId,
    required this.status,
    required this.fileType,
    required this.title,
  });

  factory UploadResult.fromJson(Map<String, dynamic> json) {
    return UploadResult(
      lessonId: (json['lesson_id'] ?? json['lessonId']) as String,
      status: json['status'] as String,
      fileType: (json['file_type'] ?? json['fileType']) as String,
      title: json['title'] as String,
    );
  }
}

class UploadService {
  final Dio _dio;

  UploadService(this._dio);

  Future<UploadResult> uploadLessonFile({
    required File file,
    String? childId,
    String? title,
  }) async {
    final fileName = file.path.split(Platform.pathSeparator).last;
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path, filename: fileName),
      if (childId != null) 'child_id': childId,
      if (title != null && title.isNotEmpty) 'title': title,
    });

    final response = await _dio.post('/upload/', data: formData);
    return UploadResult.fromJson(response.data as Map<String, dynamic>);
  }

  Future<ContentAnalysis> analyzeLesson(String lessonId) async {
    final response = await _dio.post('/games/analyze/$lessonId');
    return ContentAnalysis.fromJson(response.data as Map<String, dynamic>);
  }

  Future<ContentAnalysis> getLessonAnalysis(String lessonId) async {
    final response = await _dio.get('/games/analysis/$lessonId');
    return ContentAnalysis.fromJson(response.data as Map<String, dynamic>);
  }

  Future<Lesson> getLesson(String lessonId) async {
    final response = await _dio.get('/upload/lessons/$lessonId');
    return Lesson.fromJson(response.data as Map<String, dynamic>);
  }

  Future<List<Lesson>> getLessons() async {
    final response = await _dio.get('/upload/lessons');
    if (response.data is List) {
      return (response.data as List)
          .map((e) => Lesson.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }
}
