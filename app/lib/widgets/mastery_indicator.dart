import 'package:flutter/material.dart';

class MasteryIndicator extends StatelessWidget {
  final String concept;
  final double percentage;

  const MasteryIndicator({super.key, required this.concept, required this.percentage});

  Color get _color {
    if (percentage < 0.3) return Colors.red;
    if (percentage < 0.6) return Colors.yellow;
    if (percentage < 0.85) return Colors.lightGreen;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(shape: BoxShape.circle, color: _color),
        ),
        const SizedBox(width: 8),
        Expanded(child: Text(concept, style: const TextStyle(fontWeight: FontWeight.w500))),
        Text('${(percentage * 100).toInt()}%', style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
