import 'dart:io';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import '../../data/database/database.dart';
import 'package:drift/drift.dart';
import 'package:intl/intl.dart';

class ExcelService {
  Future<List<AncRecordsCompanion>> parseExcel(String path) async {
    final bytes = File(path).readAsBytesSync();
    final decoder = SpreadsheetDecoder.decodeBytes(bytes);
    final table = decoder.tables.keys.first;
    final sheet = decoder.tables[table];

    if (sheet == null) return [];

    List<AncRecordsCompanion> records = [];

    // Skip header (assuming row 0 is header)
    for (int i = 1; i < sheet.rows.length; i++) {
      final row = sheet.rows[i];
      if (row.isEmpty) continue;

      try {
        records.add(
          AncRecordsCompanion(
            serialNumber: Value(int.tryParse(row[0]?.toString() ?? '')),
            subCentre: Value(row[1]?.toString()),
            ancId: Value(row[2]?.toString()),
            name: Value(row[3]?.toString()),
            contactNumber: Value(row[4]?.toString()),
            lmp: Value(_parseDate(row[5])),
            edd: Value(_parseDate(row[6])),
            husbandName: Value(row[7]?.toString()),
            village: Value(row[8]?.toString()),
            age: Value(int.tryParse(row[9]?.toString() ?? '')),
            gravida: Value(int.tryParse(row[10]?.toString() ?? '')),
            previousDeliveryMode: Value(row[11]?.toString()),
            highRiskCause: Value(row[12]?.toString()),
            birthPlan: Value(row[13]?.toString()),
            deliveryDate: Value(_parseDate(row[14])),
            deliveryAddress: Value(row[15]?.toString()),
            deliveryMode: Value(row[16]?.toString()),
            ashaName: Value(row[17]?.toString()),
            ashaContact: Value(row[18]?.toString()),
            status: Value(_deriveStatus(row[14], row[16])),
          ),
        );
      } catch (e) {
        // print("Error parsing row $i: $e"); // ignored in prod
      }
    }
    return records;
  }

  DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) {
      // Try common formats
      try {
        return DateFormat('dd-MM-yyyy').parse(value);
      } catch (_) {}
      try {
        return DateFormat('dd/MM/yyyy').parse(value);
      } catch (_) {}
      try {
        return DateTime.tryParse(value);
      } catch (_) {}
    }
    return null;
  }

  String _deriveStatus(dynamic deliveryDate, dynamic deliveryMode) {
    if (deliveryDate != null ||
        (deliveryMode != null && deliveryMode.toString().isNotEmpty)) {
      return 'Delivered';
    }
    return 'Pending';
  }
}
