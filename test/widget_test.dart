
import 'package:flutter_test/flutter_test.dart';
import 'package:my_dear_diary/app/my_dear_diary_app.dart';

void main() {
  testWidgets('Dashboard smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyDearDiaryApp());

    // Verify that the dashboard page is displayed.
    expect(find.text('Dashboard'), findsOneWidget);
  });
}