import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../config/dependency_injection.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/game_specification.dart';
import '../../../services/game_service.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/confetti_overlay.dart';
import '../../../widgets/streak_badge.dart';
import 'engine/renderers/multiple_choice_renderer.dart';
import 'engine/renderers/matching_renderer.dart';
import 'engine/renderers/ordering_renderer.dart';
import 'engine/renderers/boss_battle_renderer.dart';

class GamePlayScreen extends ConsumerStatefulWidget {
  final String gameId;
  final String sessionId;

  const GamePlayScreen({
    required this.gameId,
    required this.sessionId,
    super.key,
  });

  @override
  ConsumerState<GamePlayScreen> createState() => _GamePlayScreenState();
}

class _GamePlayScreenState extends ConsumerState<GamePlayScreen> {
  GameSpecification? _game;
  bool _isLoading = true;
  int _currentLevelIndex = 0;
  int _score = 0;
  int _xpEarned = 0;
  int _streak = 0;
  int _lives = 3;
  bool _isLevelComplete = false;
  bool _isMissionComplete = false;

  @override
  void initState() {
    super.initState();
    _loadGame();
  }

  Future<void> _loadGame() async {
    setState(() => _isLoading = true);
    try {
      final repo = ref.read(gameRepositoryProvider);
      final game = await repo.getGame(widget.gameId);
      if (mounted) {
        setState(() {
          _game = game;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _onAnswerSubmitted(bool isCorrect, dynamic answer, String explanation) {
    if (_game != null) {
      final currentLevel = _game!.levels[_currentLevelIndex];
      final String questionId = currentLevel.id;
      final String? conceptId = currentLevel.conceptIds.isNotEmpty ? currentLevel.conceptIds.first : null;
      
      final request = SubmitAnswerRequest(
        questionId: questionId,
        conceptId: conceptId,
        answerGiven: answer,
        responseTimeMs: 2500, // Optional: measure real time
      );
      
      ref.read(gameServiceProvider).submitAnswer(widget.sessionId, request).catchError((e) {
        debugPrint('Failed to submit answer: $e');
        return const AnswerResult(isCorrect: false, explanation: '', xpEarned: 0);
      });
    }

    setState(() {
      if (isCorrect) {
        _score += 100;
        _xpEarned += _game?.levels[_currentLevelIndex].xpReward ?? 50;
        _streak += 1;
        _isLevelComplete = true;
      } else {
        _streak = 0;
        if (_lives > 1) {
          _lives -= 1;
        }
      }
    });

    if (isCorrect && _currentLevelIndex >= (_game?.levels.length ?? 1) - 1) {
      // Mission Complete!
      setState(() {
        _isMissionComplete = true;
      });
      ref.read(gameServiceProvider).completeSession(widget.sessionId).catchError((e) {
        debugPrint('Failed to complete session: $e');
        throw e;
      });
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) ConfettiOverlay.show(context);
      });
    }
  }

  void _goToNextLevel() {
    if (_game == null) return;
    if (_currentLevelIndex < _game!.levels.length - 1) {
      setState(() {
        _currentLevelIndex++;
        _isLevelComplete = false;
      });
    } else {
      setState(() {
        _isMissionComplete = true;
      });
      ref.read(gameServiceProvider).completeSession(widget.sessionId).catchError((e) {
        debugPrint('Failed to complete session: $e');
        throw e;
      });
      ConfettiOverlay.show(context);
    }
  }

  Widget _buildLevelRenderer(GameLevel level) {
    if (level.content is MultipleChoiceContent) {
      return MultipleChoiceRenderer(
        content: level.content as MultipleChoiceContent,
        onAnswerSubmitted: (isCorrect, index, expl) => _onAnswerSubmitted(isCorrect, index, expl),
      );
    } else if (level.content is MatchingContent) {
      return MatchingRenderer(
        content: level.content as MatchingContent,
        onAnswerSubmitted: (isCorrect, answer, expl) => _onAnswerSubmitted(isCorrect, answer, expl),
      );
    } else if (level.content is OrderingContent) {
      return OrderingRenderer(
        content: level.content as OrderingContent,
        onAnswerSubmitted: (isCorrect, order, expl) => _onAnswerSubmitted(isCorrect, order, expl),
      );
    } else if (level.content is BossBattleContent) {
      return BossBattleRenderer(
        content: level.content as BossBattleContent,
        onBossDefeated: (isVictory, expl) => _onAnswerSubmitted(isVictory, true, expl),
      );
    }

    return Center(child: Text(AppLocalizations.of(context)!.unknownLevel));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context)!;

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_game == null || _game!.levels.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(l.mission)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(l.failedLoadGame),
              const SizedBox(height: 16),
              AppButton.primary(
                label: l.backToMissions,
                onPressed: () => context.go('/child'),
              ),
            ],
          ),
        ),
      );
    }

    if (_isMissionComplete) {
      // Mission Complete Screen
      return Scaffold(
        body: ConfettiOverlay(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  theme.colorScheme.primary,
                  const Color(0xFF4A3E9E),
                ],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.emoji_events, size: 72, color: Colors.amber),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      '${l.missionCompleted} 🏆',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _game!.title,
                      style: const TextStyle(color: Colors.white70, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // Stats Card
                    AppCard.elevated(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(l.score, style: const TextStyle(color: Colors.grey)),
                              const SizedBox(height: 4),
                              Text(
                                '$_score',
                                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(l.xpEarned, style: const TextStyle(color: Colors.grey)),
                              const SizedBox(height: 4),
                              Text(
                                '+$_xpEarned',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(l.streak, style: const TextStyle(color: Colors.grey)),
                              const SizedBox(height: 4),
                              Text(
                                '$_streak 🔥',
                                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    AppButton.game(
                      label: '🎮 ${l.playAgain}',
                      onPressed: () {
                        setState(() {
                          _currentLevelIndex = 0;
                          _isLevelComplete = false;
                          _isMissionComplete = false;
                          _score = 0;
                          _xpEarned = 0;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    AppButton.secondary(
                      label: l.backToMissions,
                      onPressed: () => context.go('/child'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    final currentLevel = _game!.levels[_currentLevelIndex];
    final isBossLevel = currentLevel.isBoss || currentLevel.type == LevelType.bossBattle;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () async {
            final router = GoRouter.of(context);
            final exit = await showDialog<bool>(
              context: context,
              builder: (c) => AlertDialog(
                title: Text(l.exitMission),
                content: Text(l.exitMissionBody),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(c, false), child: Text(l.keepPlaying)),
                  TextButton(onPressed: () => Navigator.pop(c, true), child: Text(l.exit)),
                ],
              ),
            );
            if (exit == true && mounted) {
              router.go('/child');
            }
          },
        ),
        title: Text('${l.level} ${_currentLevelIndex + 1}/${_game!.levels.length}'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: StreakBadge(streak: _streak),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Row(
                children: List.generate(
                  3,
                  (index) => Icon(
                    index < _lives ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _isLevelComplete && !_isMissionComplete
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: AppButton.game(
                  label: _currentLevelIndex < _game!.levels.length - 1
                      ? '🚀 ${l.nextLevel}'
                      : '🏆 ${l.finishMission}',
                  onPressed: _goToNextLevel,
                ),
              ),
            )
          : null,
      body: SafeArea(
        child: Column(
          children: [
            // Linear Progress Bar
            LinearProgressIndicator(
              value: (_currentLevelIndex + 1) / _game!.levels.length,
              minHeight: 6,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation(
                isBossLevel ? Colors.red : theme.colorScheme.primary,
              ),
            ),

            // Active Renderer
            Expanded(
              child: _buildLevelRenderer(currentLevel),
            ),
          ],
        ),
      ),
    );
  }
}
