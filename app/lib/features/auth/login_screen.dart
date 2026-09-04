import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'providers/auth_provider.dart';
import '../../config/locale_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_colors.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_input.dart';
import '../../widgets/language_toggle.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final l = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await ref.read(authProvider.notifier).login(
            _emailController.text.trim(),
            _passwordController.text,
          );
      if (mounted) {
        context.go('/');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l.loginFailed}: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: LanguageToggle(
                    isArabic: ref.watch(localeProvider).languageCode == 'ar',
                    onToggle: () => ref.read(localeProvider.notifier).toggle(),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Container(
                    width: 84,
                    height: 84,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.35),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.auto_awesome, size: 44, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  l.welcomeBack,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  l.signInSubtitle,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                AppInput(
                  controller: _emailController,
                  label: l.email,
                  hint: l.enterEmail,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email_outlined),
                  validator: (value) {
                    if (value == null || value.isEmpty) return l.pleaseEnterEmail;
                    if (!value.contains('@')) return l.invalidEmail;
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                AppInput.password(
                  controller: _passwordController,
                  label: l.password,
                  hint: l.enterPassword,
                  prefixIcon: const Icon(Icons.lock_outline),
                  validator: (value) {
                    if (value == null || value.isEmpty) return l.pleaseEnterPassword;
                    if (value.length < 6) return l.passwordTooShort;
                    return null;
                  },
                ),
                const SizedBox(height: 28),
                AppButton.primary(
                  label: l.login,
                  isLoading: _isLoading,
                  onPressed: _login,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(l.dontHaveAccount),
                    TextButton(
                      onPressed: () => context.push('/register'),
                      child: Text(l.register),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
