import 'package:dio/dio.dart';
import '../models/child_profile.dart';

class CreateChildRequest {
  final String name;
  final int age;
  final String? avatar;
  final String? preferredLanguage;
  final String? gradeLevel;
  final List<String> preferredSubjects;

  CreateChildRequest({
    required this.name,
    required this.age,
    this.avatar,
    this.preferredLanguage,
    this.gradeLevel,
    this.preferredSubjects = const [],
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'age': age,
        if (avatar != null) 'avatar': avatar,
        if (preferredLanguage != null) 'preferred_language': preferredLanguage,
        if (gradeLevel != null) 'grade_level': gradeLevel,
        'preferred_subjects': preferredSubjects,
      };
}

class UpdateChildRequest {
  final String? name;
  final int? age;
  final String? avatar;
  final String? preferredLanguage;
  final String? gradeLevel;
  final List<String>? preferredSubjects;

  UpdateChildRequest({
    this.name,
    this.age,
    this.avatar,
    this.preferredLanguage,
    this.gradeLevel,
    this.preferredSubjects,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (age != null) data['age'] = age;
    if (avatar != null) data['avatar'] = avatar;
    if (preferredLanguage != null) data['preferred_language'] = preferredLanguage;
    if (gradeLevel != null) data['grade_level'] = gradeLevel;
    if (preferredSubjects != null) data['preferred_subjects'] = preferredSubjects;
    return data;
  }
}

class ChildService {
  final Dio _dio;

  ChildService(this._dio);

  Future<ChildProfile> createChild(CreateChildRequest request) async {
    final response = await _dio.post('/children/', data: request.toJson());
    return ChildProfile.fromJson(response.data as Map<String, dynamic>);
  }

  Future<List<ChildProfile>> getChildren() async {
    final response = await _dio.get('/children/');
    if (response.data is Map && response.data['children'] != null) {
      final list = response.data['children'] as List;
      return list.map((e) => ChildProfile.fromJson(e as Map<String, dynamic>)).toList();
    } else if (response.data is List) {
      return (response.data as List)
          .map((e) => ChildProfile.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<ChildProfile> getChild(String id) async {
    final response = await _dio.get('/children/$id');
    return ChildProfile.fromJson(response.data as Map<String, dynamic>);
  }

  Future<ChildProfile> updateChild(String id, UpdateChildRequest request) async {
    final response = await _dio.put('/children/$id', data: request.toJson());
    return ChildProfile.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> deleteChild(String id) async {
    await _dio.delete('/children/$id');
  }
}
