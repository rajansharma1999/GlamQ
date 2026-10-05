import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/app.dart';

/// Main entry point for the GlamQ application.
///
/// We wrap [GlamQApp] inside a [ProviderScope].
/// In Riverpod, [ProviderScope] stores the state of all providers across the app.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: GlamQApp(),
    ),
  );
}
