import 'dart:typed_data';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import '../../data/database/database.dart';
import 'package:drift/drift.dart';
import 'package:intl/intl.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;

class ExcelService {
  Future<List<AncRecordsCompanion>> parseExcel(Uint8List bytes) async {
    List<List<dynamic>> rows = [];

    // 1. Try parsing directly (XLSX or supported formats)
    try {
      rows = _decodeWithSpreadsheetDecoder(bytes);
    } catch (_) {
      // 2. If valid spreadsheet decoding fails, try HTML table (Fake XLS)
      try {
        final content = String.fromCharCodes(bytes);
        // Simple validity check for HTML-like content
        if (content.trim().startsWith('<')) {
          rows = _parseHtmlTable(content);
        } else {
          rethrow;
        }
      } catch (_) {
        // If all attempts fail
        throw Exception(
            'Unsupported file format. Binary .xls files are not supported. Please save as .xlsx or generic HTML report.');
      }
    }

    if (rows.isEmpty) return [];

    return _processRows(rows);
  }

  // Helper to decode bytes using spreadsheet_decoder
  List<List<dynamic>> _decodeWithSpreadsheetDecoder(Uint8List bytes) {
    final decoder = SpreadsheetDecoder.decodeBytes(bytes);
    // Determine which table to use.
    // Usually the first one is the active sheet.
    if (decoder.tables.isEmpty) return [];

    final table = decoder.tables.keys.first;
    final sheet = decoder.tables[table];
    return sheet?.rows ?? [];
  }

  List<List<dynamic>> _parseHtmlTable(String content) {
    try {
      var document = parse(content);
      // Find the first likely table
      var table = document.querySelector('table');
      if (table == null) return [];

      List<List<dynamic>> tableRows = [];
      var rows = table.querySelectorAll('tr');

      for (var row in rows) {
        var cells = row.querySelectorAll('th, td');
        var rowData = cells.map((e) => e.text.trim()).toList();
        tableRows.add(rowData);
      }
      return tableRows;
    } catch (e) {
      return [];
    }
  }

  // Refactored logic to process rows regardless of source
  List<AncRecordsCompanion> _processRows(List<List<dynamic>> rows) {
    List<AncRecordsCompanion> records = [];
    int? headerRowIndex;
    Map<String, int> columnMap = {};
    
    final expectedColumns = {
      's.no': 'serialNumber',
      'motherid': 'ancId', 
      'subcenter': 'subCentre',
      'mother name': 'name',
      'mobile': 'contactNumber',
      'edd date': 'edd',
      'district': 'district',
      'phc': 'phc',
    };

    for (int i = 0; i < rows.length; i++) {
      final row = rows[i];
      if (row.isEmpty) continue;
      
      bool isHeader = false;
      if (row.any((cell) => cell.toString().toLowerCase().contains('motherid')) && 
          row.any((cell) => cell.toString().toLowerCase().contains('edd date'))) {
        isHeader = true;
      }

      if (isHeader) {
        headerRowIndex = i;
        for (int j = 0; j < row.length; j++) {
          final cellValue = row[j]?.toString().toLowerCase().trim() ?? '';
          if (expectedColumns.containsKey(cellValue)) {
            columnMap[expectedColumns[cellValue]!] = j;
          }
        }
        break;
      }
    }

    if (headerRowIndex == null) return [];

    for (int i = headerRowIndex + 1; i < rows.length; i++) {
      final row = rows[i];
      if (row.isEmpty) continue;

      try {
        String? getVal(String key) {
          if (columnMap.containsKey(key)) {
            final index = columnMap[key]!;
            if (index < row.length) {
              return row[index]?.toString().trim();
            }
          }
          return null;
        }

        final serialNum = int.tryParse(getVal('serialNumber') ?? '');
        if (getVal('ancId') == null && getVal('name') == null) continue;

        records.add(
          AncRecordsCompanion(
            serialNumber: Value(serialNum),
            subCentre: Value(getVal('subCentre')),
            ancId: Value(getVal('ancId')),
            name: Value(getVal('name')),
            contactNumber: Value(getVal('contactNumber')),
            edd: Value(_parseDate(getVal('edd'))),
            status: const Value('Pending'), 
          ),
        );
      } catch (e) {
        // ignore
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


}
