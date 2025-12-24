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
  
  // Note: Assuming 'deliveryAddress' dictates Govt vs Private, logic can be refined
  // For now generic place holders if we don't have exact column mapping
}
