// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_analysis.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContentAnalysis _$ContentAnalysisFromJson(Map<String, dynamic> json) =>
    ContentAnalysis(
      id: json['id'] as String,
      lessonId: json['lesson_id'] as String,
      subject: json['subject'] as String?,
      topic: json['topic'] as String?,
      language: json['language'] as String?,
      estimatedGrade: json['estimated_grade'] as String?,
      difficulty: json['difficulty'] as String?,
      summary: json['summary'] as String?,
      concepts: json['concepts'] as Map<String, dynamic>? ?? {},
      learningObjectives: json['learning_objectives'] as List<dynamic>? ?? [],
      importantFacts: json['important_facts'] as List<dynamic>? ?? [],
      terminology: json['terminology'] as Map<String, dynamic>? ?? {},
      potentialQuestions: json['potential_questions'] as List<dynamic>? ?? [],
      promptVersion: json['prompt_version'] as String?,
      inputTokens: (json['input_tokens'] as num?)?.toInt(),
      outputTokens: (json['output_tokens'] as num?)?.toInt(),
      estimatedCost: (json['estimated_cost'] as num?)?.toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$ContentAnalysisToJson(ContentAnalysis instance) =>
    <String, dynamic>{
      'id': instance.id,
      'lesson_id': instance.lessonId,
      'subject': instance.subject,
      'topic': instance.topic,
      'language': instance.language,
      'estimated_grade': instance.estimatedGrade,
      'difficulty': instance.difficulty,
      'summary': instance.summary,
      'concepts': instance.concepts,
      'learning_objectives': instance.learningObjectives,
      'important_facts': instance.importantFacts,
      'terminology': instance.terminology,
      'potential_questions': instance.potentialQuestions,
      'prompt_version': instance.promptVersion,
      'input_tokens': instance.inputTokens,
      'output_tokens': instance.outputTokens,
      'estimated_cost': instance.estimatedCost,
      'created_at': instance.createdAt.toIso8601String(),
    };
