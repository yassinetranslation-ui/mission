import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class ConfettiOverlay extends StatefulWidget {
  final Widget child;
  const ConfettiOverlay({super.key, required this.child});

  static void show(BuildContext context) {
    final state = context.findAncestorStateOfType<_ConfettiOverlayState>();
    state?.play();
  }

  @override
  State<ConfettiOverlay> createState() => _ConfettiOverlayState();
}

class _ConfettiOverlayState extends State<ConfettiOverlay> {
  late ConfettiController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ConfettiController(duration: const Duration(seconds: 2));
  }

  void play() => _controller.play();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _controller,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple],
          ),
        ),
      ],
    );
  }
}
