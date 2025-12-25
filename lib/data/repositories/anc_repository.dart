import 'package:drift/drift.dart';
import '../database/database.dart';

class AncRepository {
  final AppDatabase _db;

  AncRepository(this._db);

  Future<int> insertAncRecord(AncRecordsCompanion record) {
    return _db.into(_db.ancRecords).insert(record, mode: InsertMode.insertOrReplace);
  }

  Future<List<AncRecord>> getAllAncRecords() {
    return _db.select(_db.ancRecords).get();
  }
  
  Future<List<AncRecord>> getEddsForMonth(DateTime month) {
    // Logic to filter by EDD month
    // Simplified for now, can be expanded
    return (_db.select(_db.ancRecords)
      ..where((tbl) => tbl.edd.isNotNull()))
      .get();
  }

  Future<void> updateStatus(int id, String status) {
    return (_db.update(_db.ancRecords)..where((t) => t.id.equals(id))).write(
      AncRecordsCompanion(status: Value(status)),
    );
  }

  // Dashboard Stats
  Future<int> getTotalEdds() async {
    final countExp = _db.ancRecords.id.count();
    final query = _db.selectOnly(_db.ancRecords)..addColumns([countExp]);
    return await query.map((row) => row.read(countExp)).getSingle() ?? 0;
  }
  
  Future<int> getDeliveredCount() async {
     final countExp = _db.ancRecords.id.count();
    final query = _db.selectOnly(_db.ancRecords)
      ..addColumns([countExp])
      ..where(_db.ancRecords.status.equals('Delivered'));
    return await query.map((row) => row.read(countExp)).getSingle() ?? 0;
  }

  Future<int> getNormalDeliveryCount() async {
     final countExp = _db.ancRecords.id.count();
    final query = _db.selectOnly(_db.ancRecords)
      ..addColumns([countExp])
      ..where(_db.ancRecords.deliveryMode.equals('Normal'));
    return await query.map((row) => row.read(countExp)).getSingle() ?? 0;
  }

  Future<int> getLscsDeliveryCount() async {
     final countExp = _db.ancRecords.id.count();
    final query = _db.selectOnly(_db.ancRecords)
      ..addColumns([countExp])
      ..where(_db.ancRecords.deliveryMode.contains('LSCS') | _db.ancRecords.deliveryMode.contains('C-Section'));
    return await query.map((row) => row.read(countExp)).getSingle() ?? 0;
  }
  
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

      // Delivery Place (Simple heuristic based on available data)
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
}

class MonthStats {
  final int year;
  final int month;
  int total;
  int normal;
  int lscs;
  int abortion;
  int govt;
  int private;

  MonthStats({
    required this.year,
    required this.month,
    required this.total,
    required this.normal,
    required this.lscs,
    required this.abortion,
    required this.govt,
    required this.private,
  });
}
