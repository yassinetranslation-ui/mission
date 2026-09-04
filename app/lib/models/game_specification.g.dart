// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_specification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameSpecification _$GameSpecificationFromJson(Map<String, dynamic> json) =>
    GameSpecification(
      gameId: json['game_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      gameType: $enumDecodeNullable(_$GameTypeEnumMap, json['game_type']) ??
          GameType.adventure,
      language: json['language'] as String? ?? 'ar',
      ageRange: AgeRange.fromJson(json['age_range'] as Map<String, dynamic>),
      estimatedDurationMinutes:
          (json['estimated_duration_minutes'] as num?)?.toInt() ?? 10,
      difficulty: (json['difficulty'] as num?)?.toInt() ?? 3,
      xpReward: (json['xp_reward'] as num?)?.toInt() ?? 500,
      conceptIds: (json['concept_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      narrative: json['narrative'] == null
          ? null
          : GameNarrative.fromJson(json['narrative'] as Map<String, dynamic>),
      levels: (json['levels'] as List<dynamic>)
          .map((e) => GameLevel.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$GameSpecificationToJson(GameSpecification instance) =>
    <String, dynamic>{
      'game_id': instance.gameId,
      'title': instance.title,
      'description': instance.description,
      'game_type': _$GameTypeEnumMap[instance.gameType]!,
      'language': instance.language,
      'age_range': instance.ageRange,
      'estimated_duration_minutes': instance.estimatedDurationMinutes,
      'difficulty': instance.difficulty,
      'xp_reward': instance.xpReward,
      'concept_ids': instance.conceptIds,
      'narrative': instance.narrative,
      'levels': instance.levels,
      'created_at': instance.createdAt?.toIso8601String(),
    };

const _$GameTypeEnumMap = {
  GameType.multipleChoice: 'multipleChoice',
  GameType.matching: 'matching',
  GameType.ordering: 'ordering',
  GameType.bossBattle: 'bossBattle',
  GameType.mixed: 'mixed',
  GameType.adventure: 'adventure',
};

AgeRange _$AgeRangeFromJson(Map<String, dynamic> json) => AgeRange(
      min: (json['min'] as num?)?.toInt() ?? 8,
      max: (json['max'] as num?)?.toInt() ?? 12,
    );

Map<String, dynamic> _$AgeRangeToJson(AgeRange instance) => <String, dynamic>{
      'min': instance.min,
      'max': instance.max,
    };

GameNarrative _$GameNarrativeFromJson(Map<String, dynamic> json) =>
    GameNarrative(
      missionTitle: json['mission_title'] as String,
      missionDescription: json['mission_description'] as String,
      characterName: json['character_name'] as String?,
      backstory: json['backstory'] as String?,
    );

Map<String, dynamic> _$GameNarrativeToJson(GameNarrative instance) =>
    <String, dynamic>{
      'mission_title': instance.missionTitle,
      'mission_description': instance.missionDescription,
      'character_name': instance.characterName,
      'backstory': instance.backstory,
    };

GameLevel _$GameLevelFromJson(Map<String, dynamic> json) => GameLevel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      type: $enumDecodeNullable(_$LevelTypeEnumMap, json['type']) ??
          LevelType.multipleChoice,
      order: (json['order'] as num?)?.toInt() ?? 1,
      content: const LevelContentConverter()
          .fromJson(json['content'] as Map<String, dynamic>),
      conceptIds: (json['concept_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      sourceFactIds: (json['source_fact_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      xpReward: (json['xp_reward'] as num?)?.toInt() ?? 80,
      isBoss: json['is_boss'] as bool? ?? false,
    );

Map<String, dynamic> _$GameLevelToJson(GameLevel instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'type': _$LevelTypeEnumMap[instance.type]!,
      'order': instance.order,
      'content': const LevelContentConverter().toJson(instance.content),
      'concept_ids': instance.conceptIds,
      'source_fact_ids': instance.sourceFactIds,
      'xp_reward': instance.xpReward,
      'is_boss': instance.isBoss,
    };

const _$LevelTypeEnumMap = {
  LevelType.multipleChoice: 'multipleChoice',
  LevelType.matching: 'matching',
  LevelType.ordering: 'ordering',
  LevelType.bossBattle: 'bossBattle',
};

MultipleChoiceContent _$MultipleChoiceContentFromJson(
        Map<String, dynamic> json) =>
    MultipleChoiceContent(
      question: json['question'] as String,
      choices:
          (json['choices'] as List<dynamic>).map((e) => e as String).toList(),
      correctAnswer: (json['correct_answer'] as num?)?.toInt() ?? 0,
      explanation: json['explanation'] as String,
      hint: json['hint'] as String?,
    );

Map<String, dynamic> _$MultipleChoiceContentToJson(
        MultipleChoiceContent instance) =>
    <String, dynamic>{
      'question': instance.question,
      'choices': instance.choices,
      'correct_answer': instance.correctAnswer,
      'explanation': instance.explanation,
      'hint': instance.hint,
    };

MatchingContent _$MatchingContentFromJson(Map<String, dynamic> json) =>
    MatchingContent(
      instruction: json['instruction'] as String,
      pairs: (json['pairs'] as List<dynamic>)
          .map((e) => MatchPair.fromJson(e as Map<String, dynamic>))
          .toList(),
      explanation: json['explanation'] as String,
    );

Map<String, dynamic> _$MatchingContentToJson(MatchingContent instance) =>
    <String, dynamic>{
      'instruction': instance.instruction,
      'pairs': instance.pairs,
      'explanation': instance.explanation,
    };

MatchPair _$MatchPairFromJson(Map<String, dynamic> json) => MatchPair(
      left: json['left'] as String,
      right: json['right'] as String,
    );

Map<String, dynamic> _$MatchPairToJson(MatchPair instance) => <String, dynamic>{
      'left': instance.left,
      'right': instance.right,
    };

OrderingContent _$OrderingContentFromJson(Map<String, dynamic> json) =>
    OrderingContent(
      instruction: json['instruction'] as String,
      items: (json['items'] as List<dynamic>).map((e) => e as String).toList(),
      correctOrder: (json['correct_order'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      explanation: json['explanation'] as String,
    );

Map<String, dynamic> _$OrderingContentToJson(OrderingContent instance) =>
    <String, dynamic>{
      'instruction': instance.instruction,
      'items': instance.items,
      'correct_order': instance.correctOrder,
      'explanation': instance.explanation,
    };

BossBattleContent _$BossBattleContentFromJson(Map<String, dynamic> json) =>
    BossBattleContent(
      title: json['title'] as String,
      description: json['description'] as String,
      challenges: (json['challenges'] as List<dynamic>)
          .map((e) => BossChallenge.fromJson(e as Map<String, dynamic>))
          .toList(),
      timeLimit: (json['time_limit'] as num?)?.toInt(),
    );

Map<String, dynamic> _$BossBattleContentToJson(BossBattleContent instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'challenges': instance.challenges,
      'time_limit': instance.timeLimit,
    };

BossChallenge _$BossChallengeFromJson(Map<String, dynamic> json) =>
    BossChallenge(
      type: $enumDecode(_$LevelTypeEnumMap, json['type']),
      content: const LevelContentConverter()
          .fromJson(json['content'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BossChallengeToJson(BossChallenge instance) =>
    <String, dynamic>{
      'type': _$LevelTypeEnumMap[instance.type]!,
      'content': const LevelContentConverter().toJson(instance.content),
    };
