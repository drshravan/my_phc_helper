import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:my_phc_helper/main.dart'; // Imports main but we'll use a testable widget wrapper if needed
import 'package:my_phc_helper/screens/home_screen/home_screen.dart';
import 'package:my_phc_helper/data/database/database.dart';
import 'package:my_phc_helper/data/repositories/anc_repository.dart';
import 'package:drift/native.dart'; // For in-memory db

void main() {
  setUp(() {
    // Reset GetX
    Get.reset();

    // Mock Database for testing
    final db =
        AppDatabase(); // Drift defaults to in-memory for tests usually, or we can explicit
    // Actually AppDatabase uses `_openConnection` which is platform specific.
    // We might need to override or just let it run if it supports sqlite3 (which it does via sqlite3_flutter_libs)

    Get.put(db);
    Get.put(AncRepository(db));
  });

  testWidgets('Full App Navigation Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // 1. Verify Home Screen
    expect(find.text('PHC Malkapur'), findsOneWidget);
    expect(find.text('Programs'), findsOneWidget);

    // 2. Navigate to Programs
    await tester.tap(find.text('Programs'));
    await tester.pumpAndSettle();

    // Verify Programs Screen
    expect(find.text('MCH'), findsOneWidget);

    // 3. Navigate to MCH
    await tester.tap(find.text('MCH'));
    await tester.pumpAndSettle();

    // Verify MCH Screen
    expect(find.text('Registration'), findsOneWidget);
    expect(find.text('EDD List'), findsOneWidget);

    // 4. Navigate to EDD List
    await tester.tap(find.text('EDD List'));
    await tester.pumpAndSettle();

    // Verify EDD Screen & Dashboard Tab (Default)
    expect(find.text('EDD & Deliveries'), findsOneWidget);
    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('LSCS Rate'), findsOneWidget); // Part of Dashboard

    // 5. Switch to EDDs Tab
    await tester.tap(find.text('EDDs'));
    await tester.pumpAndSettle();

    // Verify FAB exists
    expect(find.byIcon(Icons.upload_file), findsOneWidget);
  });
}
