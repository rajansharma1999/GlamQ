import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/extensions/context_extensions.dart';

/// Baseline App Shell Screen.
///
/// This serves as the initial landing screen during the foundation phase.
/// It confirms that Riverpod state management, GoRouter routing,
/// and Material 3 theme configurations are operating cleanly.
class AppShellScreen extends StatelessWidget {
  const AppShellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppConstants.appName,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // App Icon / Brand Badge
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: context.colorScheme.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.spa_outlined,
                        size: 36,
                        color: context.colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Title & Tagline
                  Text(
                    AppConstants.appName,
                    textAlign: TextAlign.center,
                    style: context.textTheme.displaySmall?.copyWith(
                      color: context.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppConstants.appTagline,
                    textAlign: TextAlign.center,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.theme.brightness == Brightness.dark
                          ? Colors.grey.shade400
                          : Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Foundation Status Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.check_circle_outline,
                                color: context.colorScheme.secondary,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Foundation Ready',
                                style: context.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Divider(),
                          const SizedBox(height: 12),
                          _buildStatusItem(
                            context,
                            title: 'Architecture',
                            description: 'Feature-First + Clean Layers (Presentation, Domain, Data)',
                          ),
                          const SizedBox(height: 10),
                          _buildStatusItem(
                            context,
                            title: 'State Management',
                            description: 'Riverpod ProviderScope configured',
                          ),
                          const SizedBox(height: 10),
                          _buildStatusItem(
                            context,
                            title: 'Navigation',
                            description: 'go_router centralized routing enabled',
                          ),
                          const SizedBox(height: 10),
                          _buildStatusItem(
                            context,
                            title: 'MVP Focus',
                            description: 'Salon, Barber, Parlour (Appointment + Queue)',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Beginner note
                  Text(
                    'Foundation verified successfully. Ready for incremental feature development.',
                    textAlign: TextAlign.center,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.theme.brightness == Brightness.dark
                          ? Colors.grey.shade500
                          : Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusItem(
    BuildContext context, {
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 4),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: context.colorScheme.primary,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                description,
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.theme.brightness == Brightness.dark
                      ? Colors.grey.shade400
                      : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
