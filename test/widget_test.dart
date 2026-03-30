import 'package:flutter_test/flutter_test.dart';
import 'package:easydiet/app.dart';
import 'package:easydiet/navigation/app_router.dart';

void main() {
  testWidgets('App renders smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(EasyDietApp(router: createAppRouter('/onboarding')));
    expect(find.text('EasyDiet'), findsWidgets);
  });
}
