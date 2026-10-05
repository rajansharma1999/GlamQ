import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glamq/app/app.dart';
import 'package:glamq/core/constants/app_constants.dart';

void main() {
  testWidgets('GlamQ app loads foundation and displays branding', (WidgetTester tester) async {
    // Build the GlamQ root application wrapped in ProviderScope.
    await tester.pumpWidget(
      const ProviderScope(
        child: GlamQApp(),
      ),
    );

    // Let the GoRouter and widget tree settle.
    await tester.pumpAndSettle();

    // Verify that the GlamQ app bar title and branding appear.
    expect(find.text(AppConstants.appName), findsWidgets);
    expect(find.text('Foundation Ready'), findsOneWidget);
  });
}
