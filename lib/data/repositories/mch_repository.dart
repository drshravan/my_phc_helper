import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_phc_helper/data/models/anc_record_model.dart';
import 'package:my_phc_helper/data/models/stats_models.dart';

class MchRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Singleton
  static final MchRepository _instance = MchRepository._internal();
  factory MchRepository() => _instance;
  MchRepository._internal();

  // --- Helper Methods ---
  
  String _getMonthId(DateTime date) {
    // Format: "Jan-2026"
    final months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    return "${months[date.month - 1]}-${date.year}";
  }

  // Reference to the 'months' collection (acts as an index)
  CollectionReference get _monthsIndex => 
      _firestore.collection('mch').doc('edds').collection('months');

  // Reference to a specific month's record collection
  CollectionReference<AncRecordModel> _recordsRef(String monthId) {
    return _monthsIndex.doc(monthId).collection('records').withConverter<AncRecordModel>(
      fromFirestore: AncRecordModel.fromFirestore,
      toFirestore: (model, _) => model.toFirestore(),
    );
  }

  // --- CRUD Operations ---

  /// Add or Update a Record
  Future<void> addAncRecord(AncRecordModel record) async {
    if (record.edd == null) throw Exception("EDD is required to assign a month folder");
    
    final monthId = _getMonthId(record.edd!);
    
    // 1. Ensure Month Doc exists (for listing)
    await _monthsIndex.doc(monthId).set({
      'year': record.edd!.year,
      'month': record.edd!.month,
      'id': monthId,
      'lastUpdated': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    // 2. Add/Update Record in Subcollection
    final collection = _recordsRef(monthId);
    
    if (record.id != null) {
      // NOTE: If user changes EDD Month, we should technically move the document. 
      // For simplicity in this refactor, we assume EDD month doesn't drastically change 
      // or we just write to the new location. (Deleting old is complex without knowing old EDD).
      await collection.doc(record.id).set(record, SetOptions(merge: true));
    } else {
      await collection.add(record);
    }
  }

  /// Batch Add Records (Optimized for Bulk Import)
  Future<void> batchAddAncRecords(List<AncRecordModel> records) async {
    if (records.isEmpty) return;

    WriteBatch batch = _firestore.batch();
    int count = 0;
    final Set<String> processedMonthIds = {};

    for (var record in records) {
      if (record.edd == null) continue;
      
      final monthId = _getMonthId(record.edd!);
      
      // 1. Ensure Month Doc exists (Only write once per monthId per batch cycle ideally)
      //    We add it to batch if not already processed in this call
      if (!processedMonthIds.contains(monthId)) {
        batch.set(_monthsIndex.doc(monthId), {
          'year': record.edd!.year,
          'month': record.edd!.month,
          'id': monthId,
          'lastUpdated': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        processedMonthIds.add(monthId);
        count++; // Counts as a write
      }

      // 2. Add Record
      final collection = _recordsRef(monthId);
      final docRef = record.id != null ? collection.doc(record.id) : collection.doc();
      // Ensure local object has the new ID if it was null
      record.id = docRef.id; 
      
      batch.set(docRef, record, SetOptions(merge: true));
      count++;

      // Commit if size limit reached (Firestore limit is 500)
      if (count >= 490) {
        await batch.commit();
        batch = _firestore.batch();
        count = 0;
        processedMonthIds.clear(); // Reset for next batch to safe-guard map size
      }
    }

    // Commit remaining
    if (count > 0) {
      await batch.commit();
    }
  }

  /// Get Records for a specific Month & Year
  Stream<List<AncRecordModel>> getRecordsForMonth(int year, int month) {
    final date = DateTime(year, month, 1);
    final monthId = _getMonthId(date);
    
    return _recordsRef(monthId)
        .orderBy('edd')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  /// Get Counts for Month (aggregated by SubCenter)
  Future<Map<String, int>> getCountForMonth(int year, int month) async {
    final date = DateTime(year, month, 1);
    final monthId = _getMonthId(date);
    
    final querySnapshot = await _recordsRef(monthId).get();

    final Map<String, int> stats = {};
    for (var doc in querySnapshot.docs) {
      final sc = doc.data().subCentre ?? 'Unknown';
      stats[sc] = (stats[sc] ?? 0) + 1;
    }
    return stats;
  }

  /// Delete all records for a month
  Future<void> deleteRecordsForMonth(int year, int month) async {
    final date = DateTime(year, month, 1);
    final monthId = _getMonthId(date);
    final collection = _recordsRef(monthId);

    final querySnapshot = await collection.get();
    final batch = _firestore.batch();
    
    for (var doc in querySnapshot.docs) {
      batch.delete(doc.reference);
    }
    
    // Also delete the month index doc if empty
    batch.delete(_monthsIndex.doc(monthId));
    
    await batch.commit();
  }
  
  /// Delete a single record (Need EDD to find it easily, but we might only have ID)
  /// If we only have ID, we must search globally or require EDD. 
  /// For now, we assume we know the path or use collectionGroup for ID lookup (expensive).
  /// Updated signature to take year/month if possible, or fallback.
  Future<void> deleteRecord(String id, [DateTime? edd]) async {
    if (edd != null) {
      final monthId = _getMonthId(edd);
      await _recordsRef(monthId).doc(id).delete();
    } else {
      // Fallback: This is risky/slow without knowing the month. Avoid using without EDD.
      print("Warning: deleteRecord called without EDD. Cannot locate in monthly buckets efficiently.");
    }
  }

  /// Get All Records (Global Search via Collection Group)
  /// NOTE: 'records' matches the subcollection name we used above.
  Future<List<AncRecordModel>> getAllAncRecords() async {
    try {
      final snapshot = await _firestore.collectionGroup('records')
          .withConverter<AncRecordModel>(
            fromFirestore: AncRecordModel.fromFirestore,
            toFirestore: (model, _) => model.toFirestore(),
          )
          .get();
          
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print("Error fetching all records: $e");
      rethrow;
    }
  }

  /// Aggregation Logic (Now Iterates Active Months)
  Future<List<MonthStats>> getAggregatedMonths() async {
    // 1. Get List of Months from Index
    final monthDocs = await _monthsIndex.get();
    
    List<MonthStats> results = [];
    
    for (var doc in monthDocs.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final year = data['year'] as int;
      final month = data['month'] as int;
      final monthId = data['id'] as String;

      // 2. Fetch records for this month to calc stats
      // Optimization: We could store stats in the month doc itself during 'add'.
      // For now, we calculate fresh to ensure accuracy.
      final recordsRef = _recordsRef(monthId);
      final recordsSnap = await recordsRef.get();
      final records = recordsSnap.docs.map((d) => d.data()).toList();
      
      var stats = MonthStats(
          year: year,
          month: month,
          total: 0, normal: 0, lscs: 0, abortion: 0, govt: 0, private: 0
      );

      for (var record in records) {
         stats.total++;
         
         final mode = record.deliveryMode?.toLowerCase() ?? '';
         if (mode.contains('normal')) stats.normal++;
         else if (mode.contains('lscs') || mode.contains('c-section')) stats.lscs++;
         else if (mode.contains('abortion')) stats.abortion++;

         final place = record.deliveryAddress?.toLowerCase() ?? '';
         final type = record.deliveryHospitalType?.toLowerCase() ?? '';
         if (type.contains('govt') || place.contains('govt') || place.contains('phc')) stats.govt++;
         else if (type.contains('private') || place.contains('pvt')) stats.private++;
      }
      
      results.add(stats);
    }

    return results
      ..sort((a, b) => DateTime(b.year, b.month).compareTo(DateTime(a.year, a.month)));
  }

  /// Sub-Center Aggregation Logic (Global)
  Future<List<SubCenterStats>> getSubCenterStats() async {
    // Use Collection Group for global calculation
    final allRecords = await getAllAncRecords();
    Map<String, SubCenterStats> grouped = {};

    for (var record in allRecords) {
      final sc = record.subCentre?.trim() ?? "Unknown";

      if (!grouped.containsKey(sc)) {
        grouped[sc] = SubCenterStats(
          subCenterName: sc,
          normal: 0, lscs: 0, abortion: 0, govt: 0, private: 0,
          totalDeliveries: 0, pendingDeliveryUpdates: 0, pendingDetails: 0, totalBeneficiaries: 0,
        );
      }

      final stats = grouped[sc]!;
      stats.totalBeneficiaries++;
      
      // ... (Rest of logic is same, copied below for safety in replacement)
      final status = record.status.toLowerCase();
      if (status == 'delivered') {
        stats.totalDeliveries++;
        final mode = record.deliveryMode?.toLowerCase() ?? '';
        if (mode.contains('normal')) stats.normal++;
        else if (mode.contains('lscs') || mode.contains('c-section')) stats.lscs++;

        final place = record.deliveryAddress?.toLowerCase() ?? '';
        final type = record.deliveryHospitalType?.toLowerCase() ?? '';
        if (type.contains('govt') || place.contains('govt')) stats.govt++;
        else if (type.contains('private') || place.contains('pvt')) stats.private++;
      } else if (status == 'aborted') {
        stats.abortion++;
      } else {
        stats.pendingDeliveryUpdates++;
      }

      bool missingBasic = (record.village == null) || (record.contactNumber == null);
      if (missingBasic || record.gravida == null) stats.pendingDetails++;
    }

    return grouped.values.toList()
      ..sort((a, b) => a.subCenterName.compareTo(b.subCenterName));
  }
}
