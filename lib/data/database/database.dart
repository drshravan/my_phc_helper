import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

class AncRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get serialNumber => integer().nullable()();
  TextColumn get subCentre => text().nullable()();
  TextColumn get ancId => text().unique().nullable()();
  TextColumn get name => text().nullable()();
  TextColumn get contactNumber => text().nullable()();
  DateTimeColumn get lmp => dateTime().nullable()();
  DateTimeColumn get edd => dateTime().nullable()();
  TextColumn get husbandName => text().nullable()();
  TextColumn get village => text().nullable()();
  IntColumn get age => integer().nullable()();
  IntColumn get gravida => integer().nullable()();
  TextColumn get previousDeliveryMode => text().nullable()();
  TextColumn get highRiskCause => text().nullable()();
  TextColumn get birthPlan => text().nullable()();
  DateTimeColumn get deliveryDate => dateTime().nullable()();
  TextColumn get deliveryAddress => text().nullable()();
  TextColumn get deliveryMode => text().nullable()();
  TextColumn get ashaName => text().nullable()();
  TextColumn get ashaContact => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('Pending'))();
}

@DriftDatabase(tables: [AncRecords])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'my_phc_helper_db',
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
      ),
    );
  }
}
