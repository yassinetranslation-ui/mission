import 'package:flutter/material.dart';

enum AppButtonVariant { primary, secondary, text, icon, game }
enum AppButtonSize { sm, md, lg }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final IconData? icon;
  final bool fullWidth;
  final AppButtonSize size;
  final AppButtonVariant variant;

  const AppButton.primary({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.fullWidth = true,
    this.size = AppButtonSize.md,
  }) : variant = AppButtonVariant.primary;

  const AppButton.secondary({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.fullWidth = true,
    this.size = AppButtonSize.md,
  }) : variant = AppButtonVariant.secondary;

  const AppButton.text({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.fullWidth = false,
    this.size = AppButtonSize.md,
  }) : variant = AppButtonVariant.text;

  const AppButton.icon({
    super.key,
    required this.icon,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.fullWidth = false,
    this.size = AppButtonSize.md,
  })  : variant = AppButtonVariant.icon, label = '';

  const AppButton.game({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.fullWidth = true,
    this.size = AppButtonSize.lg,
  }) : variant = AppButtonVariant.game;

  @override
  Widget build(BuildContext context) {
    final bool disabled = isDisabled || isLoading;
    final Widget buttonContent = isLoading
        ? const SizedBox(
            width: 20, height: 20,
            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) Icon(icon, size: size == AppButtonSize.sm ? 16 : 24),
              if (icon != null && label.isNotEmpty) const SizedBox(width: 8),
              if (label.isNotEmpty) Text(label),
            ],
          );

    Widget button;
    switch (variant) {
      case AppButtonVariant.primary:
        button = ElevatedButton(onPressed: disabled ? null : onPressed, child: buttonContent);
        break;
      case AppButtonVariant.secondary:
        button = OutlinedButton(onPressed: disabled ? null : onPressed, child: buttonContent);
        break;
      case AppButtonVariant.text:
        button = TextButton(onPressed: disabled ? null : onPressed, child: buttonContent);
        break;
      case AppButtonVariant.icon:
        button = IconButton(onPressed: disabled ? null : onPressed, icon: buttonContent);
        break;
      case AppButtonVariant.game:
        button = Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(colors: [Colors.orangeAccent, Colors.deepOrange]),
            boxShadow: [BoxShadow(color: Colors.orange.withValues(alpha: 0.5), blurRadius: 8, offset: const Offset(0, 4))],
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            ),
            onPressed: disabled ? null : onPressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
              child: buttonContent,
            ),
          ),
        );
        break;
    }

    return Semantics(
      button: true,
      enabled: !disabled,
      child: fullWidth ? SizedBox(width: double.infinity, child: button) : button,
    );
  }
}
