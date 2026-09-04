import 'package:json_annotation/json_annotation.dart';

part 'lesson.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Lesson {
  final String id;
  final String parentId;
  final String? childId;
  final String title;
  final String? filePath;
  @JsonKey(defaultValue: 'image')
  final String fileType;
  @JsonKey(defaultValue: 'uploaded')
  final String status;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Lesson({
    required this.id,
    required this.parentId,
    this.childId,
    required this.title,
    this.filePath,
    this.fileType = 'image',
    this.status = 'uploaded',
    required this.createdAt,
    this.updatedAt,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) => _$LessonFromJson(json);
  Map<String, dynamic> toJson() => _$LessonToJson(this);
}
