import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../shared/widgets/app_shell.dart';

/// Centralized route paths and names.
class AppRoutes {
  AppRoutes._();

  static const String root = '/';
  static const String rootName = 'root';
}

/// Central Riverpod provider for [GoRouter].
///
/// By wrapping [GoRouter] inside a Riverpod Provider, future authentication
/// and role-based redirects can listen to state changes cleanly without
/// tightly coupling routing to UI widgets.
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.root,
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: AppRoutes.root,
        name: AppRoutes.rootName,
        builder: (context, state) => const AppShellScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: Center(
        child: Text('No route defined for: ${state.uri.path}'),
      ),
    ),
  );
});
