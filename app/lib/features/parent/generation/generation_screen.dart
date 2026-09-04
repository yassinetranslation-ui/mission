import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../config/dependency_injection.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/content_analysis.dart';
import '../../../models/game_specification.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_card.dart';

class GenerationScreen extends ConsumerStatefulWidget {
  final String lessonId;

  const GenerationScreen({required this.lessonId, super.key});

  @override
  ConsumerState<GenerationScreen> createState() => _GenerationScreenState();
}

class _GenerationScreenState extends ConsumerState<GenerationScreen> {
  int _currentStepIndex = 0;
  bool _isComplete = false;
  String? _errorMessage;
  ContentAnalysis? _analysis;
  GameSpecification? _game;

  List<Map<String, dynamic>> _buildSteps(AppLocalizations l) => [
    {'icon': Icons.description_outlined, 'title': l.genStep1Title, 'subtitle': l.genStep1Sub},
    {'icon': Icons.psychology_outlined, 'title': l.genStep2Title, 'subtitle': l.genStep2Sub},
    {'icon': Icons.track_changes_outlined, 'title': l.genStep3Title, 'subtitle': l.genStep3Sub},
    {'icon': Icons.sports_esports_outlined, 'title': l.genStep4Title, 'subtitle': l.genStep4Sub},
    {'icon': Icons.extension_outlined, 'title': l.genStep5Title, 'subtitle': l.genStep5Sub},
    {'icon': Icons.check_circle_outline, 'title': l.genStep6Title, 'subtitle': l.genStep6Sub},
  ];

  @override
  void initState() {
    super.initState();
    _startGenerationPipeline();
  }

  Future<void> _startGenerationPipeline() async {
    // Step 0: Reading
    setState(() => _currentStepIndex = 0);
    await Future.delayed(const Duration(milliseconds: 700));

    // Step 1: Deconstructing
    if (!mounted) return;
    setState(() => _currentStepIndex = 1);

    try {
      final uploadService = ref.read(uploadServiceProvider);
      final gameService = ref.read(gameServiceProvider);

      // Trigger Claude API analysis in background
      final analysis = await uploadService.analyzeLesson(widget.lessonId);

      // Animate progress gracefully
      if (!mounted) return;
      setState(() {
        _currentStepIndex = 2;
        _analysis = analysis;
      });

      await Future.delayed(const Duration(milliseconds: 700));
      if (!mounted) return;
      setState(() => _currentStepIndex = 3);

      // Trigger game specification generation
      final game = await gameService.generateGame(widget.lessonId);

      if (!mounted) return;
      setState(() => _currentStepIndex = 4);

      await Future.delayed(const Duration(milliseconds: 700));
      if (!mounted) return;

      setState(() {
        _currentStepIndex = 5;
        _isComplete = true;
        _game = game;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context)!;
    final steps = _buildSteps(l);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.aiMissionGenerator),
        automaticallyImplyLeading: _isComplete || _errorMessage != null,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_errorMessage != null) ...[
                // Error State
                AppCard.outlined(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Icon(Icons.error_outline, size: 56, color: AppColors.error),
                      const SizedBox(height: 16),
                      Text(
                        l.generationError,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _errorMessage!,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 24),
                      AppButton.primary(
                        label: l.tryAgain,
                        onPressed: () {
                          setState(() {
                            _errorMessage = null;
                            _currentStepIndex = 0;
                            _isComplete = false;
                          });
                          _startGenerationPipeline();
                        },
                      ),
                    ],
                  ),
                ),
              ] else if (!_isComplete) ...[
                // Generation in Progress
                Text(
                  l.transformingLesson,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  l.claudeAnalyzing,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 36),

                // Sequential Step Animation Cards
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: steps.length - 1, // Don't show final step until done
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final step = steps[index];
                    final isDone = _currentStepIndex > index;
                    final isActive = _currentStepIndex == index;

                    Color iconColor = Colors.grey.shade400;
                    Color bgColor = theme.colorScheme.surface;
                    if (isDone) {
                      iconColor = Colors.green;
                    } else if (isActive) {
                      iconColor = theme.colorScheme.primary;
                      bgColor = theme.colorScheme.primary.withValues(alpha: 0.08);
                    }

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isActive
                              ? theme.colorScheme.primary
                              : Colors.grey.withValues(alpha: 0.2),
                          width: isActive ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          if (isActive)
                            SizedBox(
                              width: 28,
                              height: 28,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor: AlwaysStoppedAnimation(theme.colorScheme.primary),
                              ),
                            )
                          else
                            Icon(
                              isDone ? Icons.check_circle : step['icon'] as IconData,
                              color: iconColor,
                              size: 28,
                            ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  step['title'] as String,
                                  style: TextStyle(
                                    fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                                    color: isActive
                                        ? theme.colorScheme.primary
                                        : theme.colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  step['subtitle'] as String,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ] else ...[
                // Success State: Knowledge Map Summary
                AppCard.elevated(
                  gradient: AppColors.primaryGradient,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.celebration,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l.missionReady,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _game?.title ?? _analysis?.topic ?? l.eduLessonGame,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.95),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Knowledge Map Breakdown Card
                if (_analysis != null) ...[
                  AppCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '🧠 ${l.extractedKnowledgeMap}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _analysis!.summary ?? '',
                          style: theme.textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 12),

                        // Concept Chips
                        Text(
                          '${l.keyConceptsLabel} (${_analysis!.concepts.length}):',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _analysis!.concepts.entries.map((entry) {
                            return Chip(
                              label: Text(
                                entry.value.toString(),
                                style: const TextStyle(fontSize: 12),
                              ),
                              backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 16),

                        // Objectives
                        if (_analysis!.learningObjectives.isNotEmpty) ...[
                          Text(
                            '${l.learningObjectivesLabel} (${_analysis!.learningObjectives.length}):',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          for (final obj in _analysis!.learningObjectives)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 6.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.check, size: 18, color: Colors.green),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text(obj.toString())),
                                ],
                              ),
                            ),
                        ],
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 32),

                // Action Buttons
                AppButton.game(
                  label: '🎮 ${l.previewPlayMission}',
                  onPressed: () {
                    if (_game != null) {
                      context.push('/parent/games/${_game!.gameId}/preview');
                    } else {
                      context.go('/child');
                    }
                  },
                ),
                const SizedBox(height: 12),
                AppButton.secondary(
                  label: l.returnToDashboard,
                  onPressed: () {
                    context.go('/parent');
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
