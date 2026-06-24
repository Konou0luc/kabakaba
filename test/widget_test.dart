import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kabakaba/app/app.dart';

void main() {
  testWidgets('KabaApp builds successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: KabaApp()));

    // Verify that the app builds (or splash screen or another key widget is present
    expect(find.byType(KabaApp), findsOneWidget);
  });
}
