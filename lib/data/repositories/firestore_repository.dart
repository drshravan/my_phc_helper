import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_phc_helper/data/models/anc_record_model.dart';
import 'package:my_phc_helper/data/models/stats_models.dart';

class FirestoreRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Singleton
  static final FirestoreRepository _instance = FirestoreRepository._internal();
  factory FirestoreRepository() => _instance;
  FirestoreRepository._internal() {
    // Enable offline persistence (it's enabled by default in mobile, but good to know)
    _firestore.settings = const Settings(persistenceEnabled: true);
  }

  // Collection Reference with Converter
  CollectionReference<AncRecordModel> get _ancCollection =>
      _firestore.collection('anc_records').withConverter<AncRecordModel>(
            fromFirestore: AncRecordModel.fromFirestore,
            toFirestore: (model, _) => model.toFirestore(),
          );

  // --- CRUD Operations ---

  /// Add or Update a Record
  Future<void> addAncRecord(AncRecordModel record) async {
    if (record.id != null) {
      // Update existing
      await _ancCollection.doc(record.id).set(record, SetOptions(merge: true));
    } else {
      // Create new
      await _ancCollection.add(record);
    }
  }

  /// Get Records for a specific Month & Year (EDD)
  Stream<List<AncRecordModel>> getRecordsForMonth(int year, int month) {
    // Calculate start and end dates for the month
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 1).subtract(const Duration(milliseconds: 1));

    return _ancCollection
        .where('edd', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('edd', isLessThanOrEqualTo: Timestamp.fromDate(end))
        .orderBy('edd')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  /// Get Counts for Month (aggregated by SubCenter)
  Future<Map<String, int>> getCountForMonth(int year, int month) async {
    // Note: Firestore COUNT queries are cheaper, but for grouping we might need to fetch.
    // Optimization: If we have many records, we should maintain a separate 'stats' collection.
    // For now (MVP), we fetch and count locally on the client (offline friendly).
    
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 1).subtract(const Duration(milliseconds: 1));

    // We use .get(GetOptions(source: Source.cache)) first to make it fast offline?
    // Actually, default is to check cache then server.
    
    final querySnapshot = await _ancCollection
        .where('edd', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('edd', isLessThanOrEqualTo: Timestamp.fromDate(end))
        .get();

    final Map<String, int> stats = {};
    for (var doc in querySnapshot.docs) {
      final sc = doc.data().subCentre ?? 'Unknown';
      stats[sc] = (stats[sc] ?? 0) + 1;
    }
    return stats;
  }

  /// Delete all records for a month (Admin/MO feature)
  Future<void> deleteRecordsForMonth(int year, int month) async {
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 1).subtract(const Duration(milliseconds: 1));

    final querySnapshot = await _ancCollection
        .where('edd', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('edd', isLessThanOrEqualTo: Timestamp.fromDate(end))
        .get();

    final batch = _firestore.batch();
    for (var doc in querySnapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
  
  /// Delete a single record
  Future<void> deleteRecord(String id) async {
    await _ancCollection.doc(id).delete();
  }
  /// Get All Records (for aggregation)
  Future<List<AncRecordModel>> getAllAncRecords() async {
    final snapshot = await _ancCollection.get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  /// Aggregation Logic (Client-Side)
  Future<List<MonthStats>> getAggregatedMonths() async {
    final allRecords = await getAllAncRecords();
    Map<String, MonthStats> grouped = {};

    for (var record in allRecords) {
      if (record.edd == null) continue;
      
      final key = "${record.edd!.year}-${record.edd!.month.toString().padLeft(2, '0')}";
      
      if (!grouped.containsKey(key)) {
        grouped[key] = MonthStats(
          year: record.edd!.year,
          month: record.edd!.month,
          total: 0,
          normal: 0,
          lscs: 0,
          abortion: 0,
          govt: 0,
          private: 0,
        );
      }

      final stats = grouped[key]!;
      stats.total++;

      // Delivery Mode
      final mode = record.deliveryMode?.toLowerCase() ?? '';
      if (mode.contains('normal')) {
        stats.normal++;
      } else if (mode.contains('lscs') || mode.contains('c-section')) stats.lscs++;
      else if (mode.contains('abortion')) stats.abortion++;

      // Delivery Place
      final place = record.deliveryAddress?.toLowerCase() ?? '';
      if (place.contains('govt') || place.contains('phc') || place.contains('dh') || place.contains('sdh')) {
        stats.govt++;
      } else if (place.contains('pvt') || place.contains('private') || place.contains('hosp')) {
        stats.private++;
      }
    }

    final sortedList = grouped.values.toList()
      ..sort((a, b) {
        final dateA = DateTime(a.year, a.month);
        final dateB = DateTime(b.year, b.month);
        return dateB.compareTo(dateA); // Newest first
      });

    return sortedList;
  }
  /// Sub-Center Aggregation Logic
  Future<List<SubCenterStats>> getSubCenterStats() async {
    final allRecords = await getAllAncRecords();
    Map<String, SubCenterStats> grouped = {};

    for (var record in allRecords) {
      final sc = record.subCentre?.trim() ?? "Unknown";

      if (!grouped.containsKey(sc)) {
        grouped[sc] = SubCenterStats(
          subCenterName: sc,
          normal: 0,
          lscs: 0,
          abortion: 0,
          govt: 0,
          private: 0,
          totalDeliveries: 0,
          pendingDeliveryUpdates: 0,
          pendingDetails: 0,
          totalBeneficiaries: 0,
        );
      }

      final stats = grouped[sc]!;
      stats.totalBeneficiaries++;
      

      // Delivery Logic
      final status = record.status.toLowerCase();
      if (status == 'delivered') {
        stats.totalDeliveries++;
        
        final mode = record.deliveryMode?.toLowerCase() ?? '';
        if (mode.contains('normal')) {
          stats.normal++;
        } else if (mode.contains('lscs') || mode.contains('c-section')) stats.lscs++;

        final place = record.deliveryAddress?.toLowerCase() ?? ''; // OR Use deliveryHospitalType
        final type = record.deliveryHospitalType?.toLowerCase() ?? '';
        
        if (type.contains('govt') || place.contains('govt') || place.contains('phc')) {
          stats.govt++;
        } else if (type.contains('private') || place.contains('pvt')) {
          stats.private++;
        }
      } else if (status == 'aborted') {
        stats.abortion++;
      } else {
        // Pending Delivery
        stats.pendingDeliveryUpdates++;
      }

      // Data Completion Logic (Pending Details)
      // Check for mandatory fields
      bool missingBasic = (record.village == null || record.village!.isEmpty) ||
                          (record.contactNumber == null || record.contactNumber!.isEmpty) ||
                          (record.husbandName == null || record.husbandName!.isEmpty);
      
      bool missingMedical = (record.gravida == null);
      
      if (missingBasic || missingMedical) {
        stats.pendingDetails++;
      }
    }

    return grouped.values.toList()
      ..sort((a, b) => a.subCenterName.compareTo(b.subCenterName));
  }
}
