import 'package:flutter/foundation.dart';
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
  // Build the router ONCE. Re-evaluate redirects on auth changes via a
  // refreshListenable instead of recreating the whole GoRouter (which would
  // reset navigation to the initial route and break post-login navigation).
  final refresh = ValueNotifier<int>(0);
  final sub = ref.listen<AuthState>(authProvider, (_, __) => refresh.value++);
  ref.onDispose(() {
    sub.close();
    refresh.dispose();
  });

  return GoRouter(
    initialLocation: '/',
    refreshListenable: refresh,
    redirect: (context, state) {
      final auth = ref.read(authProvider);
      final loc = state.matchedLocation;
      final onSplash = loc == '/';
      final onAuthRoute = loc == '/login' || loc == '/register';
      final onOnboarding = loc.startsWith('/onboarding');

      // While auth is initializing, keep the splash visible.
      if (auth.isInitializing) return onSplash ? null : '/';

      // Not signed in: only auth routes are allowed.
      if (!auth.isAuthenticated) return onAuthRoute ? null : '/login';

      // Signed in but not onboarded: force onboarding.
      if (!auth.hasCompletedOnboarding) return onOnboarding ? null : '/onboarding';

      // Signed in and onboarded: keep out of splash/auth screens.
      if (onSplash || onAuthRoute) return '/parent';

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
