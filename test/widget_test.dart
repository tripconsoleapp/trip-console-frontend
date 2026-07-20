import 'package:flutter_test/flutter_test.dart';
import 'package:trip_console/main.dart';

void main() {
  testWidgets('App starts and shows splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const TripConsoleApp());

    expect(find.byType(TripConsoleApp), findsOneWidget);
  });
}
