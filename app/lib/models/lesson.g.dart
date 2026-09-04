// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Lesson _$LessonFromJson(Map<String, dynamic> json) => Lesson(
      id: json['id'] as String,
      parentId: json['parent_id'] as String,
      childId: json['child_id'] as String?,
      title: json['title'] as String,
      filePath: json['file_path'] as String?,
      fileType: json['file_type'] as String? ?? 'image',
      status: json['status'] as String? ?? 'uploaded',
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$LessonToJson(Lesson instance) => <String, dynamic>{
      'id': instance.id,
      'parent_id': instance.parentId,
      'child_id': instance.childId,
      'title': instance.title,
      'file_path': instance.filePath,
      'file_type': instance.fileType,
      'status': instance.status,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
