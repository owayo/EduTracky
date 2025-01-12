import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/auth/providers/auth_provider.dart';
import '../features/auth/screens/splash_screen.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/dashboard/screens/dashboard_screen.dart';
import '../features/children/screens/children_list_screen.dart';
import '../features/camera/screens/camera_screen.dart';
import '../features/camera/screens/preview_screen.dart';
import '../features/analytics/screens/analytics_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final currentUser = ref.watch(currentUserProvider);

  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      if (state.uri.path == '/') return null;

      final isLoggedIn = currentUser != null;
      final isLoggingIn = state.uri.path == '/login';

      if (!isLoggedIn) {
        return isLoggingIn ? null : '/login';
      }

      if (isLoggingIn) return '/dashboard';

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
        routes: [
          GoRoute(
            path: 'children',
            builder: (context, state) => const ChildrenListScreen(),
          ),
          GoRoute(
            path: 'camera',
            builder: (context, state) => const CameraScreen(),
            routes: [
              GoRoute(
                path: 'preview',
                builder: (context, state) {
                  final imageFile = state.extra as XFile;
                  return PreviewScreen(
                    imageFile: imageFile,
                    onRetake: () => context.pop(),
                    onConfirm: () {
                      // TODO: 画像のアップロードと処理
                      context.go('/dashboard');
                    },
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: 'analytics',
            builder: (context, state) => const AnalyticsScreen(),
          ),
        ],
      ),
    ],
  );
});