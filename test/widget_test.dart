
import 'package:flutter_test/flutter_test.dart';
import 'package:mood_tracker/main.dart';
void main() {
  testWidgets('Mood Tracker opens with three navigation tabs',
      (tester) async {
    await tester.pumpWidget(const MoodApp());
    await tester.pump();

    expect(find.text('How are you feeling today?'), findsOneWidget);
    expect(find.text('Log'), findsOneWidget);
    expect(find.text('History'), findsOneWidget);
    expect(find.text('Stats'), findsOneWidget);
  });

  testWidgets('A selected mood can be saved and viewed in History',
      (tester) async {
    await tester.pumpWidget(const MoodApp());
    await tester.pump();

    await tester.tap(find.text('Good').first);
    await tester.pump();

    await tester.tap(find.text('Save mood'));
    await tester.pump();

    expect(find.text('Mood saved successfully!'), findsOneWidget);

    await tester.tap(find.text('History'));
    await tester.pump();

    expect(find.text('Good'), findsOneWidget);
  });
}
