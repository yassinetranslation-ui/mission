import 'package:flutter/material.dart';
import '../../../../models/game_specification.dart';
import '../../../../widgets/app_card.dart';

class MatchingRenderer extends StatefulWidget {
  final MatchingContent content;
  final Function(bool isCorrect, dynamic answer, String explanation) onAnswerSubmitted;

  const MatchingRenderer({
    required this.content,
    required this.onAnswerSubmitted,
    super.key,
  });

  @override
  State<MatchingRenderer> createState() => _MatchingRendererState();
}

class _MatchingRendererState extends State<MatchingRenderer> {
  int? _selectedLeftIndex;
  final Set<int> _matchedLeftIndices = {};
  final Set<int> _matchedRightIndices = {};
  late List<int> _shuffledRightIndices;
  bool _isComplete = false;

  @override
  void initState() {
    super.initState();
    _shuffledRightIndices = List.generate(widget.content.pairs.length, (i) => i)..shuffle();
  }

  void _onLeftSelected(int index) {
    if (_matchedLeftIndices.contains(index) || _isComplete) return;
    setState(() {
      _selectedLeftIndex = index;
    });
  }

  void _onRightSelected(int shuffledIndex) {
    if (_selectedLeftIndex == null || _matchedRightIndices.contains(shuffledIndex) || _isComplete) return;

    final actualRightIndex = _shuffledRightIndices[shuffledIndex];
    if (_selectedLeftIndex == actualRightIndex) {
      // Correct Match!
      setState(() {
        _matchedLeftIndices.add(_selectedLeftIndex!);
        _matchedRightIndices.add(shuffledIndex);
        _selectedLeftIndex = null;

        if (_matchedLeftIndices.length == widget.content.pairs.length) {
          _isComplete = true;
          widget.onAnswerSubmitted(true, _matchedLeftIndices.toList(), widget.content.explanation);
        }
      });
    } else {
      // Incorrect Match feedback
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Not quite a match, try again!'),
          duration: Duration(milliseconds: 900),
        ),
      );
      setState(() {
        _selectedLeftIndex = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Instruction Header
          AppCard.elevated(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.teal.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Matching Quest',
                        style: TextStyle(
                          color: Colors.teal.shade800,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${_matchedLeftIndices.length}/${widget.content.pairs.length} Matched',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  widget.content.instruction,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Matching Columns
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Column (Terms)
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.content.pairs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final pair = widget.content.pairs[index];
                    final isMatched = _matchedLeftIndices.contains(index);
                    final isSelected = _selectedLeftIndex == index;

                    Color borderColor = Colors.grey.shade300;
                    Color bgColor = theme.colorScheme.surface;
                    if (isMatched) {
                      borderColor = Colors.green;
                      bgColor = Colors.green.shade50;
                    } else if (isSelected) {
                      borderColor = theme.colorScheme.primary;
                      bgColor = theme.colorScheme.primary.withValues(alpha: 0.1);
                    }

                    return InkWell(
                      onTap: () => _onLeftSelected(index),
                      borderRadius: BorderRadius.circular(12),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor, width: 2),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                pair.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isMatched
                                      ? Colors.green.shade800
                                      : isSelected
                                          ? theme.colorScheme.primary
                                          : theme.colorScheme.onSurface,
                                ),
                              ),
                            ),
                            if (isMatched)
                              const Icon(Icons.check_circle, color: Colors.green, size: 18),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(width: 12),

              // Right Column (Definitions)
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _shuffledRightIndices.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, shuffledIndex) {
                    final actualIndex = _shuffledRightIndices[shuffledIndex];
                    final pair = widget.content.pairs[actualIndex];
                    final isMatched = _matchedRightIndices.contains(shuffledIndex);

                    Color borderColor = Colors.grey.shade300;
                    Color bgColor = theme.colorScheme.surface;
                    if (isMatched) {
                      borderColor = Colors.green;
                      bgColor = Colors.green.shade50;
                    }

                    return InkWell(
                      onTap: () => _onRightSelected(shuffledIndex),
                      borderRadius: BorderRadius.circular(12),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor, width: 2),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                pair.right,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: isMatched ? Colors.green.shade800 : theme.colorScheme.onSurface,
                                ),
                              ),
                            ),
                            if (isMatched)
                              const Icon(Icons.check_circle, color: Colors.green, size: 18),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          if (_isComplete) ...[
            const SizedBox(height: 24),
            AppCard.elevated(
              padding: const EdgeInsets.all(20),
              color: Colors.green.shade50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.celebration, color: Colors.green.shade800),
                      const SizedBox(width: 8),
                      Text(
                        'All Pairs Matched Perfectly! 🌟',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.content.explanation,
                    style: TextStyle(color: Colors.green.shade900, height: 1.3),
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
