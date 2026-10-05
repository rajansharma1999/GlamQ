import 'package:flutter/material.dart';

/// Convenient extensions on [BuildContext] for cleaner UI code.
///
/// In Flutter, accessing themes or media queries often requires writing
/// `Theme.of(context).colorScheme.primary`. These helpers shorten that to:
/// `context.colorScheme.primary` or `context.textTheme.headlineMedium`.
extension BuildContextExtensions on BuildContext {
  /// Quick access to the current [ThemeData].
  ThemeData get theme => Theme.of(this);

  /// Quick access to the current [ColorScheme].
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Quick access to the current [TextTheme].
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Quick access to the screen [MediaQueryData].
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Screen size dimensions.
  Size get screenSize => MediaQuery.of(this).size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;

  /// True if the current theme brightness is dark.
  bool get isDarkMode => theme.brightness == Brightness.dark;
}
