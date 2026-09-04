import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color? color;
  final Gradient? gradient;
  final BorderRadius? borderRadius;
  final bool elevated;
  final bool outlined;

  const AppCard({super.key, required this.child, this.onTap, this.padding = const EdgeInsets.all(16), this.margin = EdgeInsets.zero, this.color, this.gradient, this.borderRadius, this.elevated = false, this.outlined = false});
  
  const AppCard.elevated({super.key, required this.child, this.onTap, this.padding = const EdgeInsets.all(16), this.margin = EdgeInsets.zero, this.color, this.gradient, this.borderRadius}) : elevated = true, outlined = false;
  
  const AppCard.outlined({super.key, required this.child, this.onTap, this.padding = const EdgeInsets.all(16), this.margin = EdgeInsets.zero, this.color, this.gradient, this.borderRadius}) : elevated = false, outlined = true;
  
  const AppCard.game({super.key, required this.child, this.onTap, this.padding = const EdgeInsets.all(16), this.margin = EdgeInsets.zero, this.color, this.borderRadius}) : elevated = true, outlined = false, gradient = const LinearGradient(colors: [Colors.orangeAccent, Colors.deepOrange]);

  @override
  Widget build(BuildContext context) {
    final br = borderRadius ?? BorderRadius.circular(16);
    Widget content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: gradient == null ? color ?? Theme.of(context).cardColor : null,
        gradient: gradient,
        borderRadius: br,
        border: outlined ? Border.all(color: Theme.of(context).dividerColor) : null,
        boxShadow: elevated ? [BoxShadow(color: Colors.black12, blurRadius: 8, offset: const Offset(0, 4))] : null,
      ),
      child: child,
    );

    if (onTap != null) {
      content = Padding(
        padding: margin,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: br,
            onTap: onTap,
            child: content,
          ),
        ),
      );
    } else {
      content = Padding(padding: margin, child: content);
    }
    return content;
  }
}
