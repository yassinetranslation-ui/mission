import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'providers/auth_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_colors.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_input.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final l = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await ref.read(authProvider.notifier).register(
            _emailController.text.trim(),
            _passwordController.text,
            _nameController.text.trim(),
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.createAccount)),
        );
        context.go('/login');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l.registerFailed}: ${e.toString()}')),
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
      appBar: AppBar(title: Text(l.register)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
                Center(
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.rocket_launch, size: 38, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  l.createYourAccount,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  l.registerSubtitle,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                AppInput(
                  controller: _nameController,
                  label: l.fullName,
                  hint: l.enterName,
                  prefixIcon: const Icon(Icons.person_outline),
                  validator: (value) {
                    if (value == null || value.isEmpty) return l.pleaseEnterName;
                    return null;
                  },
                ),
                const SizedBox(height: 16),
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
                  label: l.register,
                  isLoading: _isLoading,
                  onPressed: _register,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(l.alreadyHaveAccount),
                    TextButton(
                      onPressed: () => context.go('/login'),
                      child: Text(l.login),
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
