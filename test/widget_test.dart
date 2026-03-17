import 'package:flutter_test/flutter_test.dart';
import 'package:easydiet/app.dart';

void main() {
  testWidgets('App renders smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const EasyDietApp());
    expect(find.text('EasyDiet'), findsWidgets);
  });
}
