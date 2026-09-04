import 'package:flutter/material.dart';
import '../../../../models/game_specification.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_card.dart';

class OrderingRenderer extends StatefulWidget {
  final OrderingContent content;
  final Function(bool isCorrect, List<int> order, String explanation) onAnswerSubmitted;

  const OrderingRenderer({
    required this.content,
    required this.onAnswerSubmitted,
    super.key,
  });

  @override
  State<OrderingRenderer> createState() => _OrderingRendererState();
}

class _OrderingRendererState extends State<OrderingRenderer> {
  late List<int> _currentOrderIndices;
  bool _hasChecked = false;
  bool _isCorrect = false;

  @override
  void initState() {
    super.initState();
    // Start with a scrambled order or sequential
    _currentOrderIndices = List.generate(widget.content.items.length, (i) => i);
    if (_currentOrderIndices.length > 2) {
      // Scramble initially if matches exact
      _currentOrderIndices.shuffle();
    }
  }



  void _checkOrder() {
    bool correct = true;
    for (int i = 0; i < _currentOrderIndices.length; i++) {
      if (_currentOrderIndices[i] != widget.content.correctOrder[i]) {
        correct = false;
        break;
      }
    }

    setState(() {
      _hasChecked = true;
      _isCorrect = correct;
    });

    widget.onAnswerSubmitted(correct, _currentOrderIndices, widget.content.explanation);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Card
          AppCard.elevated(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Sequence Mission',
                    style: TextStyle(
                      color: Colors.orange.shade800,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.content.instruction,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Drag and drop items up or down to place them in chronological order.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Reorderable List
          ReorderableListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _currentOrderIndices.length,
            onReorderItem: (oldIndex, newIndex) {
              if (_hasChecked) return;
              setState(() {
                final item = _currentOrderIndices.removeAt(oldIndex);
                _currentOrderIndices.insert(newIndex, item);
              });
            },
            itemBuilder: (context, index) {
              final itemIndex = _currentOrderIndices[index];
              final itemText = widget.content.items[itemIndex];
              final isItemInCorrectPos = _hasChecked && itemIndex == widget.content.correctOrder[index];

              Color borderColor = Colors.grey.shade300;
              Color bgColor = theme.colorScheme.surface;
              if (_hasChecked) {
                if (isItemInCorrectPos) {
                  borderColor = Colors.green;
                  bgColor = Colors.green.shade50;
                } else {
                  borderColor = Colors.red.shade300;
                  bgColor = Colors.red.shade50;
                }
              }

              return Container(
                key: ValueKey(itemIndex),
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        itemText,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.drag_handle, color: Colors.grey),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 20),

          if (!_hasChecked)
            AppButton.game(
              label: '✅ Verify Order',
              onPressed: _checkOrder,
            )
          else ...[
            AppCard.elevated(
              padding: const EdgeInsets.all(20),
              color: _isCorrect ? Colors.green.shade50 : Colors.orange.shade50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _isCorrect ? Icons.check_circle : Icons.info_outline,
                        color: _isCorrect ? Colors.green.shade800 : Colors.orange.shade800,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _isCorrect ? 'Correct Sequence! 🎯' : 'Sequence Explanation:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _isCorrect ? Colors.green.shade900 : Colors.orange.shade900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.content.explanation,
                    style: TextStyle(
                      color: _isCorrect ? Colors.green.shade900 : Colors.orange.shade900,
                      height: 1.3,
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
