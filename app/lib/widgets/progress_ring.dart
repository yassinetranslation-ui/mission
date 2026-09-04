import 'package:flutter/material.dart';

enum ProgressRingSize { sm, md, lg }

class ProgressRing extends StatelessWidget {
  final double value; 
  final ProgressRingSize size;
  final String? label;

  const ProgressRing({super.key, required this.value, this.size = ProgressRingSize.md, this.label});

  Color _getColor() {
    if (value < 0.3) return Colors.red;
    if (value < 0.6) return Colors.yellow;
    if (value < 0.85) return Colors.lightGreen;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    double dimension = size == ProgressRingSize.sm ? 40 : size == ProgressRingSize.md ? 80 : 120;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: dimension,
          height: dimension,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: 1.0,
                strokeWidth: size == ProgressRingSize.sm ? 4 : 8,
                color: Colors.grey[200],
              ),
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: value),
                duration: const Duration(seconds: 1),
                builder: (context, animValue, _) {
                  return CircularProgressIndicator(
                    value: animValue,
                    strokeWidth: size == ProgressRingSize.sm ? 4 : 8,
                    color: _getColor(),
                  );
                },
              ),
              Center(
                child: Text(
                  '${(value * 100).toInt()}%',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: size == ProgressRingSize.sm ? 10 : size == ProgressRingSize.md ? 18 : 24,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (label != null) ...[
          const SizedBox(height: 8),
          Text(label!, style: const TextStyle(fontWeight: FontWeight.w500)),
        ]
      ],
    );
  }
}
