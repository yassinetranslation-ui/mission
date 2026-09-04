import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../config/dependency_injection.dart';
import '../../../models/learning_report.dart';
import '../../../models/learning_progress.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/progress_ring.dart';

class LearningReportScreen extends ConsumerStatefulWidget {
  final String childId;

  const LearningReportScreen({required this.childId, super.key});

  @override
  ConsumerState<LearningReportScreen> createState() => _LearningReportScreenState();
}

class _LearningReportScreenState extends ConsumerState<LearningReportScreen> {
  LearningReport? _report;
  bool _isLoading = true;
  bool _isGeneratingPractice = false;

  @override
  void initState() {
    super.initState();
    _loadReport();
  }

  Future<void> _loadReport() async {
    setState(() => _isLoading = true);
    try {
      final repo = ref.read(progressRepositoryProvider);
      final report = await repo.getLearningReport(widget.childId);
      if (mounted) {
        setState(() {
          _report = report;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _generateAdaptivePractice() async {
    if (_report == null) return;
    setState(() => _isGeneratingPractice = true);

    try {
      final weakIds = _report!.conceptBreakdown
          .where((c) => c.tier == MasteryTier.needsPractice || c.tier == MasteryTier.developing)
          .map((c) => c.conceptId)
          .toList();

      final service = ref.read(progressServiceProvider);
      final practiceGame = await service.generatePractice(widget.childId, weakIds.isNotEmpty ? weakIds : ['evaporation']);

      if (mounted) {
        context.push('/parent/games/${practiceGame.gameId}/preview');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to generate practice: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isGeneratingPractice = false);
      }
    }
  }

  Color _getTierColor(MasteryTier tier) {
    switch (tier) {
      case MasteryTier.mastered:
        return Colors.green;
      case MasteryTier.good:
        return Colors.teal;
      case MasteryTier.developing:
        return Colors.orange;
      case MasteryTier.needsPractice:
        return Colors.red;
    }
  }

  String _getTierLabel(MasteryTier tier) {
    switch (tier) {
      case MasteryTier.mastered:
        return 'Mastered 🌟';
      case MasteryTier.good:
        return 'Good 👍';
      case MasteryTier.developing:
        return 'Developing 📈';
      case MasteryTier.needsPractice:
        return 'Needs Practice 🎯';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Learning Report')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_report == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Learning Report')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.analytics_outlined, size: 56, color: Colors.grey),
              const SizedBox(height: 16),
              const Text('No learning data available yet.'),
              const SizedBox(height: 16),
              AppButton.primary(
                label: 'Back',
                onPressed: () => context.pop(),
              ),
            ],
          ),
        ),
      );
    }

    final weakConcepts = _report!.conceptBreakdown
        .where((c) => c.tier == MasteryTier.needsPractice || c.tier == MasteryTier.developing)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('${_report!.childName}\'s Report'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Overall Mastery Score Card
              AppCard.elevated(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    ProgressRing(
                      value: _report!.overallMastery / 100.0,
                      size: ProgressRingSize.lg,
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Overall Mastery',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${_report!.subject} • ${_report!.lessonTitle}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _report!.overallMastery >= 70 ? 'On Track 🚀' : 'Targeted Practice Needed',
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // AI Learning Insight
              AppCard(
                padding: const EdgeInsets.all(20),
                color: const Color(0xFF6C63FF).withValues(alpha: 0.08),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.auto_awesome, color: Color(0xFF6C63FF)),
                        const SizedBox(width: 8),
                        Text(
                          'AI Learning Insight',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF6C63FF),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _report!.aiInsight,
                      style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
                    ),
                  ],
                ),
              ),

              if (weakConcepts.isNotEmpty) ...[
                const SizedBox(height: 20),
                // Weak Concepts Callout & Adaptive Practice CTA
                AppCard.outlined(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.flag_outlined, color: Colors.orange),
                          const SizedBox(width: 8),
                          Text(
                            'Areas for Focus (${weakConcepts.length})',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Targeted micro-missions will reinforce these concepts quickly.',
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(height: 16),
                      if (_isGeneratingPractice)
                        const Center(child: CircularProgressIndicator())
                      else
                        AppButton.game(
                          label: '🎯 Generate Adaptive Practice Mission',
                          onPressed: _generateAdaptivePractice,
                        ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // Concepts Breakdown Section
              Text(
                'Concept Breakdown (${_report!.conceptBreakdown.length})',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _report!.conceptBreakdown.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final concept = _report!.conceptBreakdown[index];
                  final tierColor = _getTierColor(concept.tier);

                  return AppCard.outlined(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                concept.conceptName,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: tierColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                _getTierLabel(concept.tier),
                                style: TextStyle(
                                  color: tierColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: concept.mastery / 100.0,
                            minHeight: 8,
                            backgroundColor: Colors.grey.shade200,
                            valueColor: AlwaysStoppedAnimation(tierColor),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Mastery: ${concept.mastery.toInt()}%',
                              style: theme.textTheme.bodySmall,
                            ),
                            Text(
                              'Attempts: ${concept.attempts} (${concept.accuracy.toInt()}% accuracy)',
                              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              // Recommended Actions
              if (_report!.recommendedActions.isNotEmpty) ...[
                Text(
                  'Recommended Steps for Parents',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                AppCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: _report!.recommendedActions.map((action) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.check_circle, color: Colors.green, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                action.title.isNotEmpty ? action.title : action.description,
                                style: theme.textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
