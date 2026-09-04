import os

base_dir = r"C:\Users\Yassin\.gemini\antigravity\scratch\misson\app\lib"
models_dir = os.path.join(base_dir, "models")
services_dir = os.path.join(base_dir, "services")
repositories_dir = os.path.join(base_dir, "repositories")

os.makedirs(models_dir, exist_ok=True)
os.makedirs(services_dir, exist_ok=True)
os.makedirs(repositories_dir, exist_ok=True)

def write_file(path, content):
    with open(os.path.join(base_dir, path), "w", encoding="utf-8") as f:
        f.write(content)

# 1. user.dart
write_file("models/user.dart", """import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

enum UserRole { parent, child, teacher }

@JsonSerializable()
class User {
  final String id;
  final String email;
  final String name;
  final UserRole role;
  final String? preferredLanguage;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.preferredLanguage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
""")

# 2. child_profile.dart
write_file("models/child_profile.dart", """import 'package:json_annotation/json_annotation.dart';

part 'child_profile.g.dart';

@JsonSerializable()
class ChildProfile {
  final String id;
  final String parentId;
  final String name;
  final int age;
  final String? avatar;
  final String? preferredLanguage;
  final String? gradeLevel;
  final List<String> preferredSubjects;
  final int xpTotal;
  final int currentLevel;
  final int currentStreak;
  final DateTime? lastActivityDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ChildProfile({
    required this.id,
    required this.parentId,
    required this.name,
    required this.age,
    this.avatar,
    this.preferredLanguage,
    this.gradeLevel,
    required this.preferredSubjects,
    required this.xpTotal,
    required this.currentLevel,
    required this.currentStreak,
    this.lastActivityDate,
    required this.createdAt,
    required this.updatedAt,
  });

  int get xpForNextLevel => currentLevel * 1000;
  bool get streakIsActive {
    if (lastActivityDate == null) return false;
    final now = DateTime.now();
    final difference = now.difference(lastActivityDate!).inDays;
    return difference <= 1;
  }

  factory ChildProfile.fromJson(Map<String, dynamic> json) => _$ChildProfileFromJson(json);
  Map<String, dynamic> toJson() => _$ChildProfileToJson(this);
}
""")

# 3. lesson.dart
write_file("models/lesson.dart", """import 'package:json_annotation/json_annotation.dart';

part 'lesson.g.dart';

enum FileType { jpg, jpeg, png, pdf, docx, pptx, txt }
enum LessonStatus { uploaded, analyzing, analyzed, generating, generated, failed }

@JsonSerializable()
class Lesson {
  final String id;
  final String parentId;
  final String childId;
  final String title;
  final String? filePath;
  final FileType fileType;
  final LessonStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Lesson({
    required this.id,
    required this.parentId,
    required this.childId,
    required this.title,
    this.filePath,
    required this.fileType,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) => _$LessonFromJson(json);
  Map<String, dynamic> toJson() => _$LessonToJson(this);
}
""")

# 4. content_analysis.dart
write_file("models/content_analysis.dart", """import 'package:json_annotation/json_annotation.dart';

part 'content_analysis.g.dart';

enum Difficulty { easy, medium, hard }

@JsonSerializable()
class ContentAnalysis {
  final String id;
  final String lessonId;
  final String subject;
  final String topic;
  final String language;
  final int estimatedGrade;
  final Difficulty difficulty;
  final String summary;
  final List<ConceptNode> concepts;
  final List<String> learningObjectives;
  final List<ImportantFact> importantFacts;
  final List<TermDefinition> terminology;
  final List<String> potentialQuestions;
  final String? promptVersion;
  final int? inputTokens;
  final int? outputTokens;
  final double? estimatedCost;
  final DateTime createdAt;

  const ContentAnalysis({
    required this.id,
    required this.lessonId,
    required this.subject,
    required this.topic,
    required this.language,
    required this.estimatedGrade,
    required this.difficulty,
    required this.summary,
    required this.concepts,
    required this.learningObjectives,
    required this.importantFacts,
    required this.terminology,
    required this.potentialQuestions,
    this.promptVersion,
    this.inputTokens,
    this.outputTokens,
    this.estimatedCost,
    required this.createdAt,
  });

  factory ContentAnalysis.fromJson(Map<String, dynamic> json) => _$ContentAnalysisFromJson(json);
  Map<String, dynamic> toJson() => _$ContentAnalysisToJson(this);
}

@JsonSerializable()
class ImportantFact {
  final String id;
  final String text;
  final List<String> conceptIds;

  const ImportantFact({
    required this.id,
    required this.text,
    required this.conceptIds,
  });

  factory ImportantFact.fromJson(Map<String, dynamic> json) => _$ImportantFactFromJson(json);
  Map<String, dynamic> toJson() => _$ImportantFactToJson(this);
}

@JsonSerializable()
class TermDefinition {
  final String term;
  final String definition;
  final String? conceptId;

  const TermDefinition({
    required this.term,
    required this.definition,
    this.conceptId,
  });

  factory TermDefinition.fromJson(Map<String, dynamic> json) => _$TermDefinitionFromJson(json);
  Map<String, dynamic> toJson() => _$TermDefinitionToJson(this);
}

@JsonSerializable()
class ConceptNode {
  final String id;
  final String name;
  final String description;
  final String? parentConceptId;
  final List<ConceptNode> children;
  final List<String> sourceFactIds;

  const ConceptNode({
    required this.id,
    required this.name,
    required this.description,
    this.parentConceptId,
    required this.children,
    required this.sourceFactIds,
  });

  factory ConceptNode.fromJson(Map<String, dynamic> json) => _$ConceptNodeFromJson(json);
  Map<String, dynamic> toJson() => _$ConceptNodeToJson(this);
}
""")

# 5. game_specification.dart
write_file("models/game_specification.dart", """import 'package:json_annotation/json_annotation.dart';

part 'game_specification.g.dart';

enum GameType { multipleChoice, matching, ordering, bossBattle, mixed, adventure }
enum LevelType { multipleChoice, matching, ordering, bossBattle }

@JsonSerializable()
class GameSpecification {
  final String gameId;
  final String title;
  final String description;
  final GameType gameType;
  final String language;
  final AgeRange ageRange;
  final int estimatedDurationMinutes;
  final int difficulty;
  final int xpReward;
  final List<String> conceptIds;
  final GameNarrative? narrative;
  final List<GameLevel> levels;
  final DateTime createdAt;

  const GameSpecification({
    required this.gameId,
    required this.title,
    required this.description,
    required this.gameType,
    required this.language,
    required this.ageRange,
    required this.estimatedDurationMinutes,
    required this.difficulty,
    required this.xpReward,
    required this.conceptIds,
    this.narrative,
    required this.levels,
    required this.createdAt,
  });

  factory GameSpecification.fromJson(Map<String, dynamic> json) => _$GameSpecificationFromJson(json);
  Map<String, dynamic> toJson() => _$GameSpecificationToJson(this);
}

@JsonSerializable()
class AgeRange {
  final int min;
  final int max;

  const AgeRange({required this.min, required this.max});

  factory AgeRange.fromJson(Map<String, dynamic> json) => _$AgeRangeFromJson(json);
  Map<String, dynamic> toJson() => _$AgeRangeToJson(this);
}

@JsonSerializable()
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

@JsonSerializable()
class GameLevel {
  final String id;
  final String title;
  final String? description;
  final LevelType type;
  final int order;
  @LevelContentConverter()
  final LevelContent content;
  final List<String> conceptIds;
  final List<String> sourceFactIds;
  final int xpReward;
  final bool isBoss;

  const GameLevel({
    required this.id,
    required this.title,
    this.description,
    required this.type,
    required this.order,
    required this.content,
    required this.conceptIds,
    required this.sourceFactIds,
    required this.xpReward,
    required this.isBoss,
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
    final type = json['type'] as String?;
    switch (type) {
      case 'multipleChoice':
        return MultipleChoiceContent.fromJson(json);
      case 'matching':
        return MatchingContent.fromJson(json);
      case 'ordering':
        return OrderingContent.fromJson(json);
      case 'bossBattle':
        return BossBattleContent.fromJson(json);
      default:
        throw Exception('Unknown LevelContent type: $type');
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

@JsonSerializable()
class MultipleChoiceContent extends LevelContent {
  final String question;
  final List<String> choices;
  final int correctAnswer;
  final String explanation;
  final String? hint;

  const MultipleChoiceContent({
    required this.question,
    required this.choices,
    required this.correctAnswer,
    required this.explanation,
    this.hint,
  });

  factory MultipleChoiceContent.fromJson(Map<String, dynamic> json) => _$MultipleChoiceContentFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$MultipleChoiceContentToJson(this);
}

@JsonSerializable()
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

@JsonSerializable()
class MatchPair {
  final String left;
  final String right;

  const MatchPair({required this.left, required this.right});

  factory MatchPair.fromJson(Map<String, dynamic> json) => _$MatchPairFromJson(json);
  Map<String, dynamic> toJson() => _$MatchPairToJson(this);
}

@JsonSerializable()
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

@JsonSerializable()
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

@JsonSerializable()
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
""")

# 6. game_session.dart
write_file("models/game_session.dart", """import 'package:json_annotation/json_annotation.dart';

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
""")

# 7. learning_progress.dart
write_file("models/learning_progress.dart", """import 'package:json_annotation/json_annotation.dart';
import 'game_session.dart';

part 'learning_progress.g.dart';

enum MasteryTier { needsPractice, developing, good, mastered }

@JsonSerializable()
class LearningProgress {
  final String id;
  final String childId;
  final String conceptId;
  final String conceptName;
  final int attempts;
  final int correctAnswers;
  final double accuracy;
  final double masteryScore;
  final MasteryTier masteryTier;
  final DateTime lastAttemptAt;

  const LearningProgress({
    required this.id,
    required this.childId,
    required this.conceptId,
    required this.conceptName,
    required this.attempts,
    required this.correctAnswers,
    required this.accuracy,
    required this.masteryScore,
    required this.masteryTier,
    required this.lastAttemptAt,
  });

  static MasteryTier fromScore(double score) {
    if (score < 40) return MasteryTier.needsPractice;
    if (score < 70) return MasteryTier.developing;
    if (score < 85) return MasteryTier.good;
    return MasteryTier.mastered;
  }

  factory LearningProgress.fromJson(Map<String, dynamic> json) => _$LearningProgressFromJson(json);
  Map<String, dynamic> toJson() => _$LearningProgressToJson(this);
}

@JsonSerializable()
class ChildProgress {
  final String childId;
  final String childName;
  final double overallMastery;
  final int totalXp;
  final int gamesPlayed;
  final int conceptsLearned;
  final List<SubjectProgress> progressBySubject;
  final List<LearningProgress> weakConcepts;
  final List<LearningProgress> strongConcepts;
  final List<GameSession> recentSessions;

  const ChildProgress({
    required this.childId,
    required this.childName,
    required this.overallMastery,
    required this.totalXp,
    required this.gamesPlayed,
    required this.conceptsLearned,
    required this.progressBySubject,
    required this.weakConcepts,
    required this.strongConcepts,
    required this.recentSessions,
  });

  factory ChildProgress.fromJson(Map<String, dynamic> json) => _$ChildProgressFromJson(json);
  Map<String, dynamic> toJson() => _$ChildProgressToJson(this);
}

@JsonSerializable()
class SubjectProgress {
  final String subject;
  final String topic;
  final double mastery;
  final int conceptCount;

  const SubjectProgress({
    required this.subject,
    required this.topic,
    required this.mastery,
    required this.conceptCount,
  });

  factory SubjectProgress.fromJson(Map<String, dynamic> json) => _$SubjectProgressFromJson(json);
  Map<String, dynamic> toJson() => _$SubjectProgressToJson(this);
}
""")

# 8. achievement.dart
write_file("models/achievement.dart", """import 'package:json_annotation/json_annotation.dart';

part 'achievement.g.dart';

enum AchievementCategory { milestone, streak, mastery, exploration, special }

@JsonSerializable()
class Achievement {
  final String id;
  final String name;
  final String description;
  final String icon;
  final AchievementCategory category;
  final Map<String, dynamic> criteria;
  final int xpBonus;

  const Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.category,
    required this.criteria,
    required this.xpBonus,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) => _$AchievementFromJson(json);
  Map<String, dynamic> toJson() => _$AchievementToJson(this);

  static const List<Achievement> defaultAchievements = [
    Achievement(
      id: 'firstMission',
      name: 'First Mission',
      description: 'Complete your first learning mission',
      icon: '🚀',
      category: AchievementCategory.milestone,
      criteria: {'missionsCompleted': 1},
      xpBonus: 100,
    ),
    Achievement(
      id: 'scienceExplorer',
      name: 'Science Explorer',
      description: 'Complete 5 science missions',
      icon: '🔬',
      category: AchievementCategory.exploration,
      criteria: {'subject': 'science', 'missionsCompleted': 5},
      xpBonus: 250,
    ),
    Achievement(
      id: 'perfectScore',
      name: 'Perfect Score',
      description: 'Get 100% on any mission',
      icon: '⭐',
      category: AchievementCategory.mastery,
      criteria: {'score': 100},
      xpBonus: 200,
    ),
    Achievement(
      id: 'streak7Days',
      name: 'Week Warrior',
      description: 'Maintain a 7-day learning streak',
      icon: '🔥',
      category: AchievementCategory.streak,
      criteria: {'streakDays': 7},
      xpBonus: 500,
    ),
    Achievement(
      id: 'conceptMaster',
      name: 'Concept Master',
      description: 'Master 10 different concepts',
      icon: '🧠',
      category: AchievementCategory.mastery,
      criteria: {'masteredConcepts': 10},
      xpBonus: 400,
    ),
    Achievement(
      id: 'bossSlayer',
      name: 'Boss Slayer',
      description: 'Defeat your first boss',
      icon: '⚔️',
      category: AchievementCategory.milestone,
      criteria: {'bossesDefeated': 1},
      xpBonus: 300,
    ),
    Achievement(
      id: 'streak30Days',
      name: 'Monthly Master',
      description: 'Maintain a 30-day learning streak',
      icon: '🏆',
      category: AchievementCategory.streak,
      criteria: {'streakDays': 30},
      xpBonus: 2000,
    ),
    Achievement(
      id: 'mathWizard',
      name: 'Math Wizard',
      description: 'Complete 10 math missions',
      icon: '📐',
      category: AchievementCategory.exploration,
      criteria: {'subject': 'math', 'missionsCompleted': 10},
      xpBonus: 500,
    ),
    Achievement(
      id: 'speedDemon',
      name: 'Speed Demon',
      description: 'Complete a mission in under 2 minutes with >80% accuracy',
      icon: '⚡',
      category: AchievementCategory.special,
      criteria: {'durationSecondsMax': 120, 'minScore': 80},
      xpBonus: 350,
    ),
    Achievement(
      id: 'persistent',
      name: 'Persistent Learner',
      description: 'Retry a failed mission and get >80%',
      icon: '💪',
      category: AchievementCategory.special,
      criteria: {'retrySuccess': true},
      xpBonus: 300,
    ),
  ];
}

@JsonSerializable()
class ChildAchievement {
  final String id;
  final String childId;
  final String achievementId;
  final Achievement? achievement;
  final DateTime earnedAt;

  const ChildAchievement({
    required this.id,
    required this.childId,
    required this.achievementId,
    this.achievement,
    required this.earnedAt,
  });

  factory ChildAchievement.fromJson(Map<String, dynamic> json) => _$ChildAchievementFromJson(json);
  Map<String, dynamic> toJson() => _$ChildAchievementToJson(this);
}
""")

# 9. subscription.dart
write_file("models/subscription.dart", """import 'package:json_annotation/json_annotation.dart';

part 'subscription.g.dart';

enum SubscriptionPlan { free, plus, family, school }
enum SubscriptionStatus { active, expired, cancelled }

extension SubscriptionPlanExtension on SubscriptionPlan {
  int get defaultLimit {
    switch (this) {
      case SubscriptionPlan.free:
        return 3;
      case SubscriptionPlan.plus:
        return 50;
      case SubscriptionPlan.family:
        return 100;
      case SubscriptionPlan.school:
        return 500;
    }
  }
}

@JsonSerializable()
class Subscription {
  final String id;
  final String userId;
  final SubscriptionPlan plan;
  final int generationLimit;
  final int generationsUsed;
  final DateTime periodStart;
  final DateTime periodEnd;
  final SubscriptionStatus status;

  const Subscription({
    required this.id,
    required this.userId,
    required this.plan,
    required this.generationLimit,
    required this.generationsUsed,
    required this.periodStart,
    required this.periodEnd,
    required this.status,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) => _$SubscriptionFromJson(json);
  Map<String, dynamic> toJson() => _$SubscriptionToJson(this);
}
""")

# 10. learning_report.dart
write_file("models/learning_report.dart", """import 'package:json_annotation/json_annotation.dart';
import 'learning_progress.dart';

part 'learning_report.g.dart';

enum ActionType { practice, review, advance }

@JsonSerializable()
class LearningReport {
  final String childId;
  final String childName;
  final String lessonTitle;
  final String subject;
  final String topic;
  final double overallMastery;
  final List<ConceptMastery> conceptBreakdown;
  final String aiInsight;
  final List<RecommendedAction> recommendedActions;
  final SessionSummary sessionSummary;
  final DateTime generatedAt;

  const LearningReport({
    required this.childId,
    required this.childName,
    required this.lessonTitle,
    required this.subject,
    required this.topic,
    required this.overallMastery,
    required this.conceptBreakdown,
    required this.aiInsight,
    required this.recommendedActions,
    required this.sessionSummary,
    required this.generatedAt,
  });

  factory LearningReport.fromJson(Map<String, dynamic> json) => _$LearningReportFromJson(json);
  Map<String, dynamic> toJson() => _$LearningReportToJson(this);
}

@JsonSerializable()
class ConceptMastery {
  final String conceptId;
  final String conceptName;
  final double mastery;
  final MasteryTier tier;
  final int attempts;
  final double accuracy;

  const ConceptMastery({
    required this.conceptId,
    required this.conceptName,
    required this.mastery,
    required this.tier,
    required this.attempts,
    required this.accuracy,
  });

  factory ConceptMastery.fromJson(Map<String, dynamic> json) => _$ConceptMasteryFromJson(json);
  Map<String, dynamic> toJson() => _$ConceptMasteryToJson(this);
}

@JsonSerializable()
class RecommendedAction {
  final ActionType type;
  final String title;
  final String description;
  final List<String> conceptIds;
  final int estimatedMinutes;

  const RecommendedAction({
    required this.type,
    required this.title,
    required this.description,
    required this.conceptIds,
    required this.estimatedMinutes,
  });

  factory RecommendedAction.fromJson(Map<String, dynamic> json) => _$RecommendedActionFromJson(json);
  Map<String, dynamic> toJson() => _$RecommendedActionToJson(this);
}

@JsonSerializable()
class SessionSummary {
  final int totalSessions;
  final int totalTimeMinutes;
  final double averageScore;
  final int bestScore;
  final double improvementTrend;

  const SessionSummary({
    required this.totalSessions,
    required this.totalTimeMinutes,
    required this.averageScore,
    required this.bestScore,
    required this.improvementTrend,
  });

  factory SessionSummary.fromJson(Map<String, dynamic> json) => _$SessionSummaryFromJson(json);
  Map<String, dynamic> toJson() => _$SessionSummaryToJson(this);
}
""")

# 11. auth_service.dart
write_file("services/auth_service.dart", """import 'package:dio/dio.dart';
import '../models/user.dart';

class AuthResponse {
  final User user;
  final String accessToken;
  final String refreshToken;

  const AuthResponse({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      user: User.fromJson(json['user']),
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );
  }
}

class AuthService {
  final Dio _dio;

  AuthService(this._dio);

  Future<User> register(String email, String password, String name) async {
    final response = await _dio.post('/auth/register', data: {
      'email': email,
      'password': password,
      'name': name,
    });
    return User.fromJson(response.data);
  }

  Future<AuthResponse> login(String email, String password) async {
    final response = await _dio.post('/auth/login', data: {
      'email': email,
      'password': password,
    });
    return AuthResponse.fromJson(response.data);
  }

  Future<AuthResponse> refreshToken(String refreshToken) async {
    final response = await _dio.post('/auth/refresh', data: {
      'refreshToken': refreshToken,
    });
    return AuthResponse.fromJson(response.data);
  }

  Future<User> getCurrentUser() async {
    final response = await _dio.get('/auth/me');
    return User.fromJson(response.data);
  }

  Future<void> logout() async {
    await _dio.post('/auth/logout');
  }
}
""")

# 12. child_service.dart
write_file("services/child_service.dart", """import 'package:dio/dio.dart';
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
        if (preferredLanguage != null) 'preferredLanguage': preferredLanguage,
        if (gradeLevel != null) 'gradeLevel': gradeLevel,
        'preferredSubjects': preferredSubjects,
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
    if (preferredLanguage != null) data['preferredLanguage'] = preferredLanguage;
    if (gradeLevel != null) data['gradeLevel'] = gradeLevel;
    if (preferredSubjects != null) data['preferredSubjects'] = preferredSubjects;
    return data;
  }
}

class ChildService {
  final Dio _dio;

  ChildService(this._dio);

  Future<ChildProfile> createChild(CreateChildRequest request) async {
    final response = await _dio.post('/children', data: request.toJson());
    return ChildProfile.fromJson(response.data);
  }

  Future<List<ChildProfile>> getChildren() async {
    final response = await _dio.get('/children');
    return (response.data as List).map((e) => ChildProfile.fromJson(e)).toList();
  }

  Future<ChildProfile> getChild(String id) async {
    final response = await _dio.get('/children/$id');
    return ChildProfile.fromJson(response.data);
  }

  Future<ChildProfile> updateChild(String id, UpdateChildRequest request) async {
    final response = await _dio.patch('/children/$id', data: request.toJson());
    return ChildProfile.fromJson(response.data);
  }

  Future<void> deleteChild(String id) async {
    await _dio.delete('/children/$id');
  }
}
""")

# 13. upload_service.dart
write_file("services/upload_service.dart", """import 'dart:io';
import 'package:dio/dio.dart';
import '../models/lesson.dart';

class UploadService {
  final Dio _dio;

  UploadService(this._dio);

  Future<Lesson> uploadFile(File file, String childId, Map<String, dynamic> options) async {
    final fileName = file.path.split('/').last;
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path, filename: fileName),
      'childId': childId,
      ...options,
    });

    final response = await _dio.post('/lessons/upload', data: formData);
    return Lesson.fromJson(response.data);
  }

  Future<Lesson> getLesson(String id) async {
    final response = await _dio.get('/lessons/$id');
    return Lesson.fromJson(response.data);
  }

  Future<List<Lesson>> getLessons(String childId) async {
    final response = await _dio.get('/lessons', queryParameters: {'childId': childId});
    return (response.data as List).map((e) => Lesson.fromJson(e)).toList();
  }
}
""")

# 14. game_service.dart
write_file("services/game_service.dart", """import 'package:dio/dio.dart';
import '../models/content_analysis.dart';
import '../models/game_specification.dart';
import '../models/game_session.dart';

class SubmitAnswerRequest {
  final String questionId;
  final String conceptId;
  final dynamic answerGiven;
  final int responseTimeMs;

  SubmitAnswerRequest({
    required this.questionId,
    required this.conceptId,
    required this.answerGiven,
    required this.responseTimeMs,
  });

  Map<String, dynamic> toJson() => {
        'questionId': questionId,
        'conceptId': conceptId,
        'answerGiven': answerGiven,
        'responseTimeMs': responseTimeMs,
      };
}

class AnswerResult {
  final bool isCorrect;
  final String explanation;
  final int xpEarned;
  final String conceptId;

  const AnswerResult({
    required this.isCorrect,
    required this.explanation,
    required this.xpEarned,
    required this.conceptId,
  });

  factory AnswerResult.fromJson(Map<String, dynamic> json) {
    return AnswerResult(
      isCorrect: json['isCorrect'] as bool,
      explanation: json['explanation'] as String,
      xpEarned: json['xpEarned'] as int,
      conceptId: json['conceptId'] as String,
    );
  }
}

class GameService {
  final Dio _dio;

  GameService(this._dio);

  Future<ContentAnalysis> analyzeLesson(String lessonId) async {
    final response = await _dio.post('/games/analyze', data: {'lessonId': lessonId});
    return ContentAnalysis.fromJson(response.data);
  }

  Future<GameSpecification> generateGame(String lessonId, Map<String, dynamic> options) async {
    final response = await _dio.post('/games/generate', data: {
      'lessonId': lessonId,
      ...options,
    });
    return GameSpecification.fromJson(response.data);
  }

  Future<GameSpecification> getGame(String gameId) async {
    final response = await _dio.get('/games/$gameId');
    return GameSpecification.fromJson(response.data);
  }

  Future<List<GameSpecification>> getGamesForChild(String childId) async {
    final response = await _dio.get('/games', queryParameters: {'childId': childId});
    return (response.data as List).map((e) => GameSpecification.fromJson(e)).toList();
  }

  Future<GameSession> startSession(String gameId, String childId) async {
    final response = await _dio.post('/sessions', data: {
      'gameId': gameId,
      'childId': childId,
    });
    return GameSession.fromJson(response.data);
  }

  Future<AnswerResult> submitAnswer(String sessionId, SubmitAnswerRequest request) async {
    final response = await _dio.post('/sessions/$sessionId/answers', data: request.toJson());
    return AnswerResult.fromJson(response.data);
  }

  Future<GameSession> completeSession(String sessionId) async {
    final response = await _dio.post('/sessions/$sessionId/complete');
    return GameSession.fromJson(response.data);
  }
}
""")

# 15. progress_service.dart
write_file("services/progress_service.dart", """import 'package:dio/dio.dart';
import '../models/learning_progress.dart';
import '../models/game_specification.dart';
import '../models/learning_report.dart';

class ProgressService {
  final Dio _dio;

  ProgressService(this._dio);

  Future<ChildProgress> getChildProgress(String childId) async {
    final response = await _dio.get('/progress/$childId');
    return ChildProgress.fromJson(response.data);
  }

  Future<List<LearningProgress>> getWeakConcepts(String childId) async {
    final response = await _dio.get('/progress/$childId/weak-concepts');
    return (response.data as List).map((e) => LearningProgress.fromJson(e)).toList();
  }

  Future<GameSpecification> generatePractice(String childId, List<String> conceptIds) async {
    final response = await _dio.post('/progress/$childId/practice', data: {
      'conceptIds': conceptIds,
    });
    return GameSpecification.fromJson(response.data);
  }

  Future<LearningReport> getLearningReport(String childId, {String? lessonId}) async {
    final query = lessonId != null ? {'lessonId': lessonId} : null;
    final response = await _dio.get('/progress/$childId/report', queryParameters: query);
    return LearningReport.fromJson(response.data);
  }
}
""")

# 16. auth_repository.dart
write_file("repositories/auth_repository.dart", """import '../services/auth_service.dart';
import '../models/user.dart';

// Assuming a generic secure storage interface
abstract class SecureStorage {
  Future<void> write(String key, String value);
  Future<String?> read(String key);
  Future<void> delete(String key);
}

class AuthRepository {
  final AuthService _authService;
  final SecureStorage _secureStorage;
  
  User? _currentUser;

  AuthRepository(this._authService, this._secureStorage);

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  Future<void> init() async {
    final token = await _secureStorage.read('accessToken');
    if (token != null) {
      try {
        _currentUser = await _authService.getCurrentUser();
      } catch (e) {
        // Token might be expired
        _currentUser = null;
      }
    }
  }

  Future<User> login(String email, String password) async {
    final response = await _authService.login(email, password);
    await _secureStorage.write('accessToken', response.accessToken);
    await _secureStorage.write('refreshToken', response.refreshToken);
    _currentUser = response.user;
    return response.user;
  }

  Future<User> register(String email, String password, String name) async {
    final user = await _authService.register(email, password, name);
    // Usually login happens automatically or requires manual step
    return user;
  }

  Future<void> logout() async {
    try {
      await _authService.logout();
    } finally {
      await _secureStorage.delete('accessToken');
      await _secureStorage.delete('refreshToken');
      _currentUser = null;
    }
  }
}
""")

# 17. child_repository.dart
write_file("repositories/child_repository.dart", """import '../services/child_service.dart';
import '../models/child_profile.dart';

class ChildRepository {
  final ChildService _childService;
  
  List<ChildProfile>? _cachedChildren;

  ChildRepository(this._childService);

  Future<List<ChildProfile>> getChildren({bool forceRefresh = false}) async {
    if (_cachedChildren != null && !forceRefresh) {
      return _cachedChildren!;
    }
    
    _cachedChildren = await _childService.getChildren();
    return _cachedChildren!;
  }

  Future<ChildProfile> getChild(String id) async {
    final child = await _childService.getChild(id);
    _updateCache(child);
    return child;
  }

  Future<ChildProfile> createChild(CreateChildRequest request) async {
    final child = await _childService.createChild(request);
    _cachedChildren?.add(child);
    return child;
  }

  Future<ChildProfile> updateChild(String id, UpdateChildRequest request) async {
    final child = await _childService.updateChild(id, request);
    _updateCache(child);
    return child;
  }

  Future<void> deleteChild(String id) async {
    await _childService.deleteChild(id);
    _cachedChildren?.removeWhere((c) => c.id == id);
  }

  void _updateCache(ChildProfile child) {
    if (_cachedChildren == null) return;
    final index = _cachedChildren!.indexWhere((c) => c.id == child.id);
    if (index != -1) {
      _cachedChildren![index] = child;
    } else {
      _cachedChildren!.add(child);
    }
  }
}
""")

# 18. game_repository.dart
write_file("repositories/game_repository.dart", """import 'dart:convert';
import '../services/game_service.dart';
import '../models/game_specification.dart';

// Assuming a generic local cache interface (e.g. Hive wrapper)
abstract class LocalCache {
  Future<void> put(String key, Map<String, dynamic> value);
  Future<Map<String, dynamic>?> get(String key);
  Future<List<Map<String, dynamic>>> getAll();
}

class GameRepository {
  final GameService _gameService;
  final LocalCache _localCache;

  GameRepository(this._gameService, this._localCache);

  Future<GameSpecification> getGame(String gameId, {bool offlineMode = false}) async {
    if (offlineMode) {
      final cached = await _localCache.get('game_\$gameId');
      if (cached != null) {
        return GameSpecification.fromJson(cached);
      }
      throw Exception('Game not found in local cache');
    }

    try {
      final game = await _gameService.getGame(gameId);
      // Cache for offline play
      await _localCache.put('game_\$gameId', game.toJson());
      return game;
    } catch (e) {
      // Fallback to cache
      final cached = await _localCache.get('game_\$gameId');
      if (cached != null) {
        return GameSpecification.fromJson(cached);
      }
      rethrow;
    }
  }

  Future<List<GameSpecification>> getGamesForChild(String childId) async {
    final games = await _gameService.getGamesForChild(childId);
    for (var game in games) {
      await _localCache.put('game_\${game.gameId}', game.toJson());
    }
    return games;
  }

  Future<GameSpecification> generateGame(String lessonId, Map<String, dynamic> options) async {
    final game = await _gameService.generateGame(lessonId, options);
    await _localCache.put('game_\${game.gameId}', game.toJson());
    return game;
  }
}
""")

# 19. progress_repository.dart
write_file("repositories/progress_repository.dart", """import '../services/progress_service.dart';
import '../models/learning_progress.dart';
import '../models/learning_report.dart';

class ProgressRepository {
  final ProgressService _progressService;
  
  ChildProgress? _cachedProgress;

  ProgressRepository(this._progressService);

  Future<ChildProgress> getChildProgress(String childId, {bool forceRefresh = false}) async {
    if (_cachedProgress != null && !forceRefresh && _cachedProgress!.childId == childId) {
      return _cachedProgress!;
    }
    
    _cachedProgress = await _progressService.getChildProgress(childId);
    return _cachedProgress!;
  }

  Future<LearningReport> getLearningReport(String childId, {String? lessonId}) async {
    return _progressService.getLearningReport(childId, lessonId: lessonId);
  }
  
  void clearCache() {
    _cachedProgress = null;
  }
}
""")

print("All domain models, services, and repositories created successfully.")
