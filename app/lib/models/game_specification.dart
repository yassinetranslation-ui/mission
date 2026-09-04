import 'package:json_annotation/json_annotation.dart';

part 'game_specification.g.dart';

enum GameType {
  @JsonValue('multipleChoice')
  multipleChoice,
  @JsonValue('matching')
  matching,
  @JsonValue('ordering')
  ordering,
  @JsonValue('bossBattle')
  bossBattle,
  @JsonValue('mixed')
  mixed,
  @JsonValue('adventure')
  adventure
}

enum LevelType {
  @JsonValue('multipleChoice')
  multipleChoice,
  @JsonValue('matching')
  matching,
  @JsonValue('ordering')
  ordering,
  @JsonValue('bossBattle')
  bossBattle
}

@JsonSerializable(fieldRename: FieldRename.snake)
class GameSpecification {
  final String gameId;
  final String title;
  final String description;
  @JsonKey(defaultValue: GameType.adventure)
  final GameType gameType;
  final String language;
  final AgeRange ageRange;
  @JsonKey(defaultValue: 10)
  final int estimatedDurationMinutes;
  @JsonKey(defaultValue: 3)
  final int difficulty;
  @JsonKey(defaultValue: 500)
  final int xpReward;
  @JsonKey(defaultValue: <String>[])
  final List<String> conceptIds;
  final GameNarrative? narrative;
  final List<GameLevel> levels;
  final DateTime? createdAt;

  const GameSpecification({
    required this.gameId,
    required this.title,
    required this.description,
    this.gameType = GameType.adventure,
    this.language = 'ar',
    required this.ageRange,
    this.estimatedDurationMinutes = 10,
    this.difficulty = 3,
    this.xpReward = 500,
    this.conceptIds = const [],
    this.narrative,
    required this.levels,
    this.createdAt,
  });

  factory GameSpecification.fromJson(Map<String, dynamic> json) {
    final copy = Map<String, dynamic>.from(json);
    if (!copy.containsKey('game_id') && copy.containsKey('id')) {
      copy['game_id'] = copy['id'];
    }
    if (!copy.containsKey('game_id') && copy.containsKey('gameId')) {
      copy['game_id'] = copy['gameId'];
    }
    if (!copy.containsKey('age_range') && !copy.containsKey('ageRange')) {
      copy['age_range'] = {'min': 8, 'max': 12};
    }
    return _$GameSpecificationFromJson(copy);
  }

  Map<String, dynamic> toJson() => _$GameSpecificationToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class AgeRange {
  @JsonKey(defaultValue: 8)
  final int min;
  @JsonKey(defaultValue: 12)
  final int max;

  const AgeRange({this.min = 8, this.max = 12});

  factory AgeRange.fromJson(Map<String, dynamic> json) => _$AgeRangeFromJson(json);
  Map<String, dynamic> toJson() => _$AgeRangeToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class GameNarrative {
  final String missionTitle;
  final String missionDescription;
  final String? characterName;
  final String? backstory;

  const GameNarrative({
    required this.missionTitle,
    required this.missionDescription,
    this.characterName,
    this.backstory,
  });

  factory GameNarrative.fromJson(Map<String, dynamic> json) => _$GameNarrativeFromJson(json);
  Map<String, dynamic> toJson() => _$GameNarrativeToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class GameLevel {
  final String id;
  final String title;
  final String? description;
  @JsonKey(defaultValue: LevelType.multipleChoice)
  final LevelType type;
  @JsonKey(defaultValue: 1)
  final int order;
  @LevelContentConverter()
  final LevelContent content;
  @JsonKey(defaultValue: <String>[])
  final List<String> conceptIds;
  @JsonKey(defaultValue: <String>[])
  final List<String> sourceFactIds;
  @JsonKey(defaultValue: 80)
  final int xpReward;
  @JsonKey(defaultValue: false)
  final bool isBoss;

  const GameLevel({
    required this.id,
    required this.title,
    this.description,
    this.type = LevelType.multipleChoice,
    this.order = 1,
    required this.content,
    this.conceptIds = const [],
    this.sourceFactIds = const [],
    this.xpReward = 80,
    this.isBoss = false,
  });

  factory GameLevel.fromJson(Map<String, dynamic> json) => _$GameLevelFromJson(json);
  Map<String, dynamic> toJson() => _$GameLevelToJson(this);
}

abstract class LevelContent {
  const LevelContent();
  Map<String, dynamic> toJson();
}

class LevelContentConverter implements JsonConverter<LevelContent, Map<String, dynamic>> {
  const LevelContentConverter();

  @override
  LevelContent fromJson(Map<String, dynamic> json) {
    final type = (json['type'] as String?)?.toLowerCase();
    switch (type) {
      case 'multiplechoice':
      case 'multiple_choice':
      case 'quiz':
        return MultipleChoiceContent.fromJson(json);
      case 'matching':
        return MatchingContent.fromJson(json);
      case 'ordering':
      case 'sequence':
        return OrderingContent.fromJson(json);
      case 'bossbattle':
      case 'boss_battle':
        return BossBattleContent.fromJson(json);
      default:
        return MultipleChoiceContent.fromJson(json);
    }
  }

  @override
  Map<String, dynamic> toJson(LevelContent object) {
    final json = object.toJson();
    if (object is MultipleChoiceContent) {
      json['type'] = 'multipleChoice';
    } else if (object is MatchingContent) {
      json['type'] = 'matching';
    } else if (object is OrderingContent) {
      json['type'] = 'ordering';
    } else if (object is BossBattleContent) {
      json['type'] = 'bossBattle';
    }
    return json;
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class MultipleChoiceContent extends LevelContent {
  final String question;
  final List<String> choices;
  @JsonKey(defaultValue: 0)
  final int correctAnswer;
  final String explanation;
  final String? hint;

  const MultipleChoiceContent({
    required this.question,
    required this.choices,
    this.correctAnswer = 0,
    required this.explanation,
    this.hint,
  });

  factory MultipleChoiceContent.fromJson(Map<String, dynamic> json) => _$MultipleChoiceContentFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$MultipleChoiceContentToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class MatchingContent extends LevelContent {
  final String instruction;
  final List<MatchPair> pairs;
  final String explanation;

  const MatchingContent({
    required this.instruction,
    required this.pairs,
    required this.explanation,
  });

  factory MatchingContent.fromJson(Map<String, dynamic> json) => _$MatchingContentFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$MatchingContentToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class MatchPair {
  final String left;
  final String right;

  const MatchPair({required this.left, required this.right});

  factory MatchPair.fromJson(Map<String, dynamic> json) => _$MatchPairFromJson(json);
  Map<String, dynamic> toJson() => _$MatchPairToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class OrderingContent extends LevelContent {
  final String instruction;
  final List<String> items;
  final List<int> correctOrder;
  final String explanation;

  const OrderingContent({
    required this.instruction,
    required this.items,
    required this.correctOrder,
    required this.explanation,
  });

  factory OrderingContent.fromJson(Map<String, dynamic> json) => _$OrderingContentFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$OrderingContentToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class BossBattleContent extends LevelContent {
  final String title;
  final String description;
  final List<BossChallenge> challenges;
  final int? timeLimit;

  const BossBattleContent({
    required this.title,
    required this.description,
    required this.challenges,
    this.timeLimit,
  });

  factory BossBattleContent.fromJson(Map<String, dynamic> json) => _$BossBattleContentFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$BossBattleContentToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class BossChallenge {
  final LevelType type;
  @LevelContentConverter()
  final LevelContent content;

  const BossChallenge({
    required this.type,
    required this.content,
  });

  factory BossChallenge.fromJson(Map<String, dynamic> json) => _$BossChallengeFromJson(json);
  Map<String, dynamic> toJson() => _$BossChallengeToJson(this);
}
