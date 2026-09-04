import os

BASE_DIR = r"C:\Users\Yassin\.gemini\antigravity\scratch\misson\app\lib"

def write_file(rel_path, content):
    path = os.path.join(BASE_DIR, rel_path)
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, 'w', encoding='utf-8') as f:
        f.write(content.strip() + '\n')

# 1. Screens Boilerplate
screens = [
    ("features/splash/splash_screen.dart", "SplashScreen", []),
    ("features/onboarding/onboarding_screen.dart", "OnboardingScreen", []),
    ("features/onboarding/onboarding_profile_screen.dart", "OnboardingProfileScreen", []),
    ("features/auth/login_screen.dart", "LoginScreen", []),
    ("features/auth/register_screen.dart", "RegisterScreen", []),
    ("features/parent/home/parent_home_screen.dart", "ParentHomeScreen", []),
    ("features/parent/children/children_list_screen.dart", "ChildrenListScreen", []),
    ("features/parent/children/child_detail_screen.dart", "ChildDetailScreen", ["childId"]),
    ("features/parent/children/add_child_screen.dart", "AddChildScreen", []),
    ("features/parent/upload/upload_screen.dart", "UploadScreen", []),
    ("features/parent/generation/generation_screen.dart", "GenerationScreen", ["lessonId"]),
    ("features/parent/games/game_preview_screen.dart", "GamePreviewScreen", ["gameId"]),
    ("features/parent/reports/learning_report_screen.dart", "LearningReportScreen", ["childId"]),
    ("features/parent/reports/lesson_report_screen.dart", "LessonReportScreen", ["childId", "lessonId"]),
    ("features/parent/settings/parent_settings_screen.dart", "ParentSettingsScreen", []),
    ("features/child/home/child_home_screen.dart", "ChildHomeScreen", []),
    ("features/child/games/child_games_screen.dart", "ChildGamesScreen", []),
    ("features/child/achievements/child_achievements_screen.dart", "ChildAchievementsScreen", []),
    ("features/child/profile/child_profile_screen.dart", "ChildProfileScreen", []),
    ("features/games/game_play_screen.dart", "GamePlayScreen", ["gameId", "sessionId"]),
    ("features/parent/parent_shell_screen.dart", "ParentShellScreen", ["child"]),
    ("features/child/child_shell_screen.dart", "ChildShellScreen", ["child"]),
]

for path, cls, params in screens:
    fields = "\n  ".join([f"final {'Widget' if p == 'child' else 'String'} {p};" for p in params])
    if fields: fields = "\n  " + fields + "\n"
    
    ctor_params = ", ".join([f"required this.{p}" for p in params])
    if ctor_params: ctor_params = "{" + ctor_params + ", super.key}"
    else: ctor_params = "{super.key}"
    
    if "ShellScreen" in cls:
        body = "Scaffold(body: child, bottomNavigationBar: BottomNavigationBar(items: const [BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'), BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings')]))"
    else:
        body = f"Scaffold(appBar: AppBar(title: const Text('{cls}')), body: const Center(child: Text('{cls} - Coming Soon')))"
        
    code = f'''import 'package:flutter/material.dart';

class {cls} extends StatelessWidget {{
{fields}
  const {cls}({ctor_params});

  @override
  Widget build(BuildContext context) {{
    return {body};
  }}
}}
'''
    write_file(path, code)

# 2. Main app files
write_file("features/auth/providers/auth_provider.dart", """
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState {
  final bool isAuthenticated;
  final bool hasCompletedOnboarding;
  const AuthState({this.isAuthenticated = false, this.hasCompletedOnboarding = false});
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) => AuthNotifier());
""")

write_file("config/theme.dart", """
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      fontFamily: 'Cairo', // Default to Arabic font 
    );
  }
}
""")

write_file("config/routes.dart", """
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/auth/providers/auth_provider.dart';

import '../features/splash/splash_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/onboarding/onboarding_profile_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/register_screen.dart';
import '../features/parent/parent_shell_screen.dart';
import '../features/parent/home/parent_home_screen.dart';
import '../features/parent/children/children_list_screen.dart';
import '../features/parent/children/child_detail_screen.dart';
import '../features/parent/children/add_child_screen.dart';
import '../features/parent/upload/upload_screen.dart';
import '../features/parent/generation/generation_screen.dart';
import '../features/parent/games/game_preview_screen.dart';
import '../features/parent/reports/learning_report_screen.dart';
import '../features/parent/reports/lesson_report_screen.dart';
import '../features/parent/settings/parent_settings_screen.dart';
import '../features/child/child_shell_screen.dart';
import '../features/child/home/child_home_screen.dart';
import '../features/child/games/child_games_screen.dart';
import '../features/child/achievements/child_achievements_screen.dart';
import '../features/child/profile/child_profile_screen.dart';
import '../features/games/game_play_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isAuthRoute = state.matchedLocation == '/login' || state.matchedLocation == '/register';
      final isSplash = state.matchedLocation == '/';
      
      if (isSplash) return null;

      if (!authState.isAuthenticated && !isAuthRoute) {
        return '/login';
      }
      
      if (authState.isAuthenticated && !authState.hasCompletedOnboarding && !state.matchedLocation.startsWith('/onboarding')) {
        return '/onboarding';
      }

      if (authState.isAuthenticated && authState.hasCompletedOnboarding && isAuthRoute) {
        return '/parent'; 
      }

      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
        routes: [
          GoRoute(path: 'profile', builder: (context, state) => const OnboardingProfileScreen()),
        ]
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
      
      ShellRoute(
        builder: (context, state, child) => ParentShellScreen(child: child),
        routes: [
          GoRoute(path: '/parent', builder: (context, state) => const ParentHomeScreen()),
          GoRoute(
            path: '/parent/children',
            builder: (context, state) => const ChildrenListScreen(),
            routes: [
              GoRoute(path: 'add', builder: (context, state) => const AddChildScreen()),
              GoRoute(path: ':childId', builder: (context, state) => ChildDetailScreen(childId: state.pathParameters['childId']!)),
            ]
          ),
          GoRoute(path: '/parent/upload', builder: (context, state) => const UploadScreen()),
          GoRoute(path: '/parent/generation/:lessonId', builder: (context, state) => GenerationScreen(lessonId: state.pathParameters['lessonId']!)),
          GoRoute(path: '/parent/games/:gameId/preview', builder: (context, state) => GamePreviewScreen(gameId: state.pathParameters['gameId']!)),
          GoRoute(
            path: '/parent/reports/:childId',
            builder: (context, state) => LearningReportScreen(childId: state.pathParameters['childId']!),
            routes: [
              GoRoute(path: ':lessonId', builder: (context, state) => LessonReportScreen(childId: state.pathParameters['childId']!, lessonId: state.pathParameters['lessonId']!)),
            ]
          ),
          GoRoute(path: '/parent/settings', builder: (context, state) => const ParentSettingsScreen()),
        ],
      ),
      
      ShellRoute(
        builder: (context, state, child) => ChildShellScreen(child: child),
        routes: [
          GoRoute(path: '/child', builder: (context, state) => const ChildHomeScreen()),
          GoRoute(path: '/child/games', builder: (context, state) => const ChildGamesScreen()),
          GoRoute(path: '/child/achievements', builder: (context, state) => const ChildAchievementsScreen()),
          GoRoute(path: '/child/profile', builder: (context, state) => const ChildProfileScreen()),
        ],
      ),
      
      GoRoute(path: '/game/:gameId/:sessionId', builder: (context, state) => GamePlayScreen(gameId: state.pathParameters['gameId']!, sessionId: state.pathParameters['sessionId']!)),
    ],
  );
});
""")

write_file("main.dart", """
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'config/routes.dart';
import 'config/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive or other dependencies here
  
  runApp(
    const ProviderScope(
      child: MissonApp(),
    ),
  );
}

class MissonApp extends ConsumerWidget {
  const MissonApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Misson',
      theme: AppTheme.light,
      routerConfig: router,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar'),
        Locale('en'),
      ],
      locale: const Locale('ar'),
      debugShowCheckedModeBanner: false,
    );
  }
}
""")

# 3. Widgets
write_file("widgets/app_button.dart", """
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
            boxShadow: [BoxShadow(color: Colors.orange.withOpacity(0.5), blurRadius: 8, offset: const Offset(0, 4))],
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
""")

write_file("widgets/app_card.dart", """
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
""")

write_file("widgets/app_input.dart", """
import 'package:flutter/material.dart';

class AppInput extends StatefulWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? errorText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final int maxLines;
  final bool isSearch;

  const AppInput({super.key, this.controller, this.label, this.hint, this.errorText, this.prefixIcon, this.suffixIcon, this.obscureText = false, this.keyboardType, this.validator, this.onChanged, this.maxLines = 1, this.isSearch = false});
  const AppInput.search({super.key, this.controller, this.label, this.hint, this.errorText, this.suffixIcon, this.keyboardType, this.validator, this.onChanged, this.maxLines = 1}) : obscureText = false, isSearch = true, prefixIcon = const Icon(Icons.search);
  const AppInput.password({super.key, this.controller, this.label, this.hint, this.errorText, this.prefixIcon, this.keyboardType, this.validator, this.onChanged, this.maxLines = 1}) : obscureText = true, isSearch = false, suffixIcon = null;

  @override
  State<AppInput> createState() => _AppInputState();
}

class _AppInputState extends State<AppInput> {
  late bool _obscured;

  @override
  void initState() {
    super.initState();
    _obscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscured,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      onChanged: widget.onChanged,
      maxLines: widget.maxLines,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        errorText: widget.errorText,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.obscureText 
          ? IconButton(
              icon: Icon(_obscured ? Icons.visibility_off : Icons.visibility),
              onPressed: () => setState(() => _obscured = !_obscured),
            )
          : widget.suffixIcon,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(widget.isSearch ? 30 : 12)),
        filled: widget.isSearch,
        fillColor: widget.isSearch ? Colors.grey[200] : null,
      ),
    );
  }
}
""")

write_file("widgets/progress_ring.dart", """
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
""")

write_file("widgets/xp_bar.dart", """
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
""")

write_file("widgets/streak_badge.dart", """
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
        color: isActive ? Colors.orange.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
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
""")

write_file("widgets/mastery_indicator.dart", """
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
""")

write_file("widgets/loading_animation.dart", """
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
""")

write_file("widgets/confetti_overlay.dart", """
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
""")

write_file("widgets/empty_state.dart", """
import 'package:flutter/material.dart';
import 'app_button.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String? buttonLabel;
  final VoidCallback? onAction;

  const EmptyState({super.key, required this.icon, required this.title, required this.description, this.buttonLabel, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(description, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]), textAlign: TextAlign.center),
            if (buttonLabel != null && onAction != null) ...[
              const SizedBox(height: 24),
              AppButton.primary(label: buttonLabel!, onPressed: onAction),
            ]
          ],
        ),
      ),
    );
  }
}
""")

write_file("widgets/app_error_widget.dart", """
import 'package:flutter/material.dart';
import 'app_button.dart';

class AppErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const AppErrorWidget({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text('Oops! Something went wrong.', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[700])),
            const SizedBox(height: 24),
            AppButton.secondary(label: 'Retry', onPressed: onRetry),
          ],
        ),
      ),
    );
  }
}
""")

print("Successfully generated all misson app boilerplate files.")
