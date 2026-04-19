import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quest_bible/app/app.dart';

void main() {
  testWidgets('App renders bible screen', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: QuestBibleApp()));
    await tester.pumpAndSettle();

    expect(find.text('Quest Bible'), findsOneWidget);
    expect(find.text('Book'), findsOneWidget);
    expect(find.text('Chapter'), findsOneWidget);
  });
}
