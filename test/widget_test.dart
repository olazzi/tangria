import 'package:flutter_test/flutter_test.dart';
import 'package:tangria/app/app.dart';

void main() {
  testWidgets('App starts and renders home', (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    
    expect(find.text('Tangria'), findsOneWidget);
  });
}
