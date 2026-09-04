import 'package:flutter/material.dart';

class StreakBadge extends StatelessWidget {
  final int streak;
  final bool isActive;

  const StreakBadge({super.key, required this.streak, this.isActive = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? Colors.orange.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.local_fire_department, color: isActive ? Colors.orange : Colors.grey, size: 20),
          const SizedBox(width: 4),
          Text(
            '🔥 $streak Day Streak',
            style: TextStyle(
              color: isActive ? Colors.orange[800] : Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
