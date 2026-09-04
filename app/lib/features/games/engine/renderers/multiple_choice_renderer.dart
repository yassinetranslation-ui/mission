import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../models/game_specification.dart';
import '../../../../widgets/app_card.dart';

class MultipleChoiceRenderer extends StatefulWidget {
  final MultipleChoiceContent content;
  final Function(bool isCorrect, int selectedIndex, String explanation) onAnswerSubmitted;

  const MultipleChoiceRenderer({
    required this.content,
    required this.onAnswerSubmitted,
    super.key,
  });

  @override
  State<MultipleChoiceRenderer> createState() => _MultipleChoiceRendererState();
}

class _MultipleChoiceRendererState extends State<MultipleChoiceRenderer> {
  int? _selectedIndex;
  bool _hasSubmitted = false;
  bool _showHint = false;

  void _selectChoice(int index) {
    if (_hasSubmitted) return;
    setState(() {
      _selectedIndex = index;
      _hasSubmitted = true;
    });

    final isCorrect = index == widget.content.correctAnswer;
    widget.onAnswerSubmitted(
      isCorrect,
      index,
      widget.content.explanation,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context)!;
    final isCorrect = _selectedIndex == widget.content.correctAnswer;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Question Card
          AppCard.elevated(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        l.challenge,
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    if (widget.content.hint != null)
                      TextButton.icon(
                        icon: const Icon(Icons.lightbulb_outline, size: 18),
                        label: Text(_showHint ? l.hideHint : l.hint),
                        onPressed: () => setState(() => _showHint = !_showHint),
                      ),
                  ],
                ),
                if (_showHint && widget.content.hint != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.amber.shade300),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.lightbulb, color: Colors.amber.shade800, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.content.hint!,
                            style: TextStyle(color: Colors.amber.shade900, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Text(
                  widget.content.question,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Choices List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.content.choices.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final choice = widget.content.choices[index];
              final isThisSelected = _selectedIndex == index;
              final isThisCorrect = index == widget.content.correctAnswer;

              Color borderColor = Colors.grey.shade300;
              Color bgColor = theme.colorScheme.surface;
              Widget? trailingIcon;

              if (_hasSubmitted) {
                if (isThisCorrect) {
                  borderColor = Colors.green;
                  bgColor = Colors.green.shade50;
                  trailingIcon = const Icon(Icons.check_circle, color: Colors.green);
                } else if (isThisSelected && !isThisCorrect) {
                  borderColor = Colors.red;
                  bgColor = Colors.red.shade50;
                  trailingIcon = const Icon(Icons.cancel, color: Colors.red);
                }
              }

              final letters = ['A', 'B', 'C', 'D', 'E'];
              final prefix = index < letters.length ? letters[index] : '${index + 1}';

              return InkWell(
                onTap: () => _selectChoice(index),
                borderRadius: BorderRadius.circular(16),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: borderColor, width: 2),
                    boxShadow: [
                      if (!_hasSubmitted)
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: isThisSelected && isCorrect
                              ? Colors.green
                              : isThisSelected && !isCorrect
                                  ? Colors.red
                                  : theme.colorScheme.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            prefix,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isThisSelected ? Colors.white : theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          choice,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      if (trailingIcon != null) trailingIcon,
                    ],
                  ),
                ),
              );
            },
          ),

          if (_hasSubmitted) ...[
            const SizedBox(height: 24),
            // Explanation Card
            AppCard.elevated(
              padding: const EdgeInsets.all(20),
              color: isCorrect ? Colors.green.shade50 : Colors.orange.shade50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        isCorrect ? Icons.celebration : Icons.info_outline,
                        color: isCorrect ? Colors.green.shade800 : Colors.orange.shade800,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isCorrect ? l.correctFeedback : l.wrongFeedback,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isCorrect ? Colors.green.shade900 : Colors.orange.shade900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.content.explanation,
                    style: TextStyle(
                      color: isCorrect ? Colors.green.shade900 : Colors.orange.shade900,
                      height: 1.4,
                    ),
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
