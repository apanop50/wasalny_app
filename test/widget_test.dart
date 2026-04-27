import 'package:flutter_test/flutter_test.dart';
import 'package:wasalny_app/main.dart';

void main() {
  testWidgets('Wasalny app starts', (WidgetTester tester) async {
    await tester.pumpWidget(const WasalnyApp());
    expect(find.text('Wasalny'), findsOneWidget);
  });
}