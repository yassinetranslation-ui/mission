import '../../../models/game_specification.dart';

class GameEngineState {
  final GameSpecification game;
  final int currentLevelIndex;
  final int score;
  final int xpEarned;
  final int streak;
  final int lives;
  final int hintsRemaining;
  final bool isCompleted;
  final bool isGameOver;
  final Map<String, dynamic> levelAnswers;

  const GameEngineState({
    required this.game,
    this.currentLevelIndex = 0,
    this.score = 0,
    this.xpEarned = 0,
    this.streak = 0,
    this.lives = 3,
    this.hintsRemaining = 3,
    this.isCompleted = false,
    this.isGameOver = false,
    this.levelAnswers = const {},
  });

  GameLevel get currentLevel => game.levels[currentLevelIndex];
  bool get isLastLevel => currentLevelIndex >= game.levels.length - 1;
  double get progressPercentage => (currentLevelIndex + 1) / game.levels.length;

  GameEngineState copyWith({
    int? currentLevelIndex,
    int? score,
    int? xpEarned,
    int? streak,
    int? lives,
    int? hintsRemaining,
    bool? isCompleted,
    bool? isGameOver,
    Map<String, dynamic>? levelAnswers,
  }) {
    return GameEngineState(
      game: game,
      currentLevelIndex: currentLevelIndex ?? this.currentLevelIndex,
      score: score ?? this.score,
      xpEarned: xpEarned ?? this.xpEarned,
      streak: streak ?? this.streak,
      lives: lives ?? this.lives,
      hintsRemaining: hintsRemaining ?? this.hintsRemaining,
      isCompleted: isCompleted ?? this.isCompleted,
      isGameOver: isGameOver ?? this.isGameOver,
      levelAnswers: levelAnswers ?? this.levelAnswers,
    );
  }
}
