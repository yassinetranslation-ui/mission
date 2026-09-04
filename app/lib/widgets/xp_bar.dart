import 'package:flutter/material.dart';

class XpBar extends StatelessWidget {
  final int currentXp;
  final int nextLevelXp;
  final int level;

  const XpBar({super.key, required this.currentXp, required this.nextLevelXp, required this.level});

  @override
  Widget build(BuildContext context) {
    final double progress = (currentXp / nextLevelXp).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Level $level', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber)),
            Text('$currentXp / $nextLevelXp XP', style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            height: 12,
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: progress),
              duration: const Duration(milliseconds: 800),
              builder: (context, val, _) {
                return LinearProgressIndicator(
                  value: val,
                  backgroundColor: Colors.grey[200],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
