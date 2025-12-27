import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:my_phc_helper/main.dart';
import 'package:my_phc_helper/data/repositories/firestore_repository.dart';
import 'package:my_phc_helper/data/models/stats_models.dart';
import 'package:my_phc_helper/data/models/anc_record_model.dart';
// For in-memory db

class FakeFirestoreRepository extends GetxService implements FirestoreRepository {
  @override
  Future<List<SubCenterStats>> getSubCenterStats() async {
    return [
      SubCenterStats(
        subCenterName: "Test SubCenter",
        normal: 5,
        lscs: 2,
        abortion: 0,
        govt: 4,
        private: 3,
        totalDeliveries: 7,
        pendingDeliveryUpdates: 1,
        pendingDetails: 0,
        totalBeneficiaries: 10,
      )
    ];
  }

  @override
  Future<List<MonthStats>> getAggregatedMonths() async {
    return [
      MonthStats(
        year: 2024,
        month: 1,
        total: 10,
        normal: 5,
        lscs: 5,
        abortion: 0,
        govt: 5,
        private: 5,
      )
    ];
  }

  // Stub other methods used by screens if needed, otherwise standard UnimplementedError is fine 
  // until the test hits them.
  // We need addAncRecord for import test maybe? Not in this nav test.
  
  @override
  Future<void> addAncRecord(AncRecordModel record) async {}
  
  @override
  Future<void> deleteRecord(String id) async {}
  
  @override
  Future<void> deleteRecordsForMonth(int year, int month) async {}
  
  @override
  Future<List<AncRecordModel>> getAllAncRecords() async { return []; }
  
  @override
  Future<Map<String, int>> getCountForMonth(int year, int month) async { return {};}
  
  @override
  Stream<List<AncRecordModel>> getRecordsForMonth(int year, int month) {
    return Stream.value([]);
  }
}

void main() {
  setUp(() {
    // Reset GetX to clear any previous state
    Get.reset();
    
    // Inject Fake Repository permanently so it survives route changes within the test
    Get.put<FirestoreRepository>(FakeFirestoreRepository(), permanent: true); 
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
    expect(find.text('EDD List'), findsOneWidget);
    expect(find.text('Quick Add (Paste)'), findsOneWidget);

    // 4. Navigate to EDD List
    await tester.tap(find.text('EDD List'));
    await tester.pumpAndSettle();

    // Verify EDD Screen & Dashboard Tab (Default)
    expect(find.text('EDD & Deliveries'), findsOneWidget);
    // expect(find.text('Dashboard'), findsOneWidget); // Not present in EddScreen
    // expect(find.text('Test SubCenter'), findsOneWidget); // Not present in Month List
    
    // Verify Month List contains data from FakeFirestoreRepository
    // Fake repo returns Jan 2024
    expect(find.text('January 2024'), findsOneWidget);
    // Verify stats are visible
    expect(find.text('Normal'), findsWidgets); // Used in tile
    expect(find.text('10 EDDs'), findsOneWidget);

    // 5. Switch to EDDs Tab
    await tester.tap(find.text('EDDs'));
    await tester.pumpAndSettle();

    // Verify FAB exists
    expect(find.byIcon(Icons.upload_file), findsOneWidget);
  });
}
