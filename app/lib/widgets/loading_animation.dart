import 'package:flutter/material.dart';

class GenerationStep {
  final IconData icon;
  final String text;
  final bool isActive;
  final bool isComplete;

  GenerationStep(this.icon, this.text, {this.isActive = false, this.isComplete = false});
}

class LoadingAnimation extends StatelessWidget {
  final int variant;
  final List<GenerationStep>? steps;

  const LoadingAnimation.spinner({super.key}) : variant = 0, steps = null;
  const LoadingAnimation.dots({super.key}) : variant = 1, steps = null;
  const LoadingAnimation.generation({super.key, required this.steps}) : variant = 2;

  @override
  Widget build(BuildContext context) {
    if (variant == 0) return const CircularProgressIndicator();
    if (variant == 1) {
      return const Row(
        mainAxisSize: MainAxisSize.min,
        children: [Icon(Icons.circle, size: 8), SizedBox(width: 4), Icon(Icons.circle, size: 8), SizedBox(width: 4), Icon(Icons.circle, size: 8)],
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: steps!.map((s) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            Icon(s.icon, color: s.isComplete ? Colors.green : s.isActive ? Colors.blue : Colors.grey),
            const SizedBox(width: 8),
            Text(s.text, style: TextStyle(color: s.isActive ? Colors.black : Colors.grey, fontWeight: s.isActive ? FontWeight.bold : FontWeight.normal)),
          ],
        ),
      )).toList(),
    );
  }
}
