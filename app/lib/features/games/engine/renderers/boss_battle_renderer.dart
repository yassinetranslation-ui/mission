import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../models/game_specification.dart';
import '../../../../widgets/app_card.dart';
import 'multiple_choice_renderer.dart';

class BossBattleRenderer extends StatefulWidget {
  final BossBattleContent content;
  final Function(bool isVictory, String explanation) onBossDefeated;

  const BossBattleRenderer({
    required this.content,
    required this.onBossDefeated,
    super.key,
  });

  @override
  State<BossBattleRenderer> createState() => _BossBattleRendererState();
}

class _BossBattleRendererState extends State<BossBattleRenderer> with SingleTickerProviderStateMixin {
  int _currentChallengeIndex = 0;
  int _bossHp = 100;
  int _timeRemaining = 60;
  Timer? _timer;
  bool _isDefeated = false;
  late final AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _timeRemaining = widget.content.timeLimit ?? 60;
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeRemaining > 0) {
        setState(() => _timeRemaining--);
      } else {
        _timer?.cancel();
        // Time ran out
        if (!_isDefeated) {
          widget.onBossDefeated(false, 'Time ran out during the Boss Battle! Give it another shot.');
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _shakeController.dispose();
    super.dispose();
  }

  void _onChallengeAnswer(bool isCorrect, dynamic answer, String explanation) {
    if (isCorrect) {
      _shakeController.forward(from: 0.0);
      final totalChallenges = widget.content.challenges.length;
      final damagePerChallenge = (100 / totalChallenges).ceil();

      setState(() {
        _bossHp = (_bossHp - damagePerChallenge).clamp(0, 100);
        if (_bossHp <= 0 || _currentChallengeIndex >= totalChallenges - 1) {
          _isDefeated = true;
          _timer?.cancel();
          widget.onBossDefeated(true, 'Epic victory! You defeated the boss and restored knowledge!');
        } else {
          _currentChallengeIndex++;
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('The boss resisted your attack! Try again.'),
          duration: Duration(milliseconds: 1000),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final challenge = widget.content.challenges[_currentChallengeIndex];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Boss Battle Header Card
          AppCard.elevated(
            gradient: LinearGradient(
              colors: [
                const Color(0xFFE53935),
                const Color(0xFF8E0000),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        '🔥 BOSS BATTLE',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _timeRemaining < 15 ? Colors.red : Colors.black.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.timer, color: Colors.white, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '${_timeRemaining}s',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  widget.content.title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  widget.content.description,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // Boss Health Bar
                Row(
                  children: [
                    const Text('HP', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: _bossHp / 100.0,
                          minHeight: 14,
                          backgroundColor: Colors.black.withValues(alpha: 0.4),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _bossHp > 40 ? Colors.greenAccent : Colors.amberAccent,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text('$_bossHp%', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Active Boss Challenge
          if (!_isDefeated) ...[
            if (challenge.content is MultipleChoiceContent)
              MultipleChoiceRenderer(
                content: challenge.content as MultipleChoiceContent,
                onAnswerSubmitted: (isCorrect, index, expl) => _onChallengeAnswer(isCorrect, index, expl),
              ),
          ] else ...[
            AppCard.elevated(
              padding: const EdgeInsets.all(24),
              color: Colors.green.shade50,
              child: Column(
                children: [
                  const Icon(Icons.stars, color: Colors.amber, size: 56),
                  const SizedBox(height: 12),
                  Text(
                    'BOSS DEFEATED! 🏆',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'You cleared all challenges and mastered the entire lesson mission!',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
