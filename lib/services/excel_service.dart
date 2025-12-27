import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import '../../data/models/anc_record_model.dart';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:html/parser.dart' show parse;

class ExcelService {

  /// MAIN ENTRY
  Future<List<AncRecordModel>> parseExcel(Uint8List bytes) async {
    List<List<dynamic>> rows = [];

    // 1️⃣ Try XLSX (real supported format)
    rows = _decodeWithSpreadsheetDecoder(bytes);

    // 2️⃣ If empty, try HTML table (fake .xls from govt sites)
    if (rows.isEmpty) {
      final content = String.fromCharCodes(bytes);
      if (_looksLikeHtml(content)) {
        rows = _parseHtmlTable(content);
      }
    }

    // 3️⃣ If still empty → unsupported real binary XLS
    if (rows.isEmpty) {
      throw Exception(
        'This file is an old Excel (.xls) binary format.\n'
        'Please open it in Excel and Save As → Excel Workbook (.xlsx).',
      );
    }

    return _processRows(rows);
  }

  /// PARSE COPIED TEXT (TSV)
  Future<List<AncRecordModel>> parsePasteData(String text) async {
    List<List<dynamic>> rows = [];
    if (text.isEmpty) return [];

    // Split by newlines
    final lines = text.split('\n');
    for (var line in lines) {
      if (line.trim().isEmpty) continue;
      // Split by tabs (Excel copy puts tabs between cells)
      final cells = line.split('\t').map((e) => e.trim()).toList();
      rows.add(cells);
    }

    if (rows.isEmpty) return [];
    
    // Use the same processing logic
    return _processRows(rows);
  }

  // ===========================
  // XLSX DECODER
  // ===========================
  List<List<dynamic>> _decodeWithSpreadsheetDecoder(Uint8List bytes) {
    try {
      final decoder = SpreadsheetDecoder.decodeBytes(bytes);
      if (decoder.tables.isEmpty) return [];

      final tableName = decoder.tables.keys.first;
      return decoder.tables[tableName]?.rows ?? [];
    } catch (_) {
      return [];
    }
  }

  // ===========================
  // HTML CHECK
  // ===========================
  bool _looksLikeHtml(String content) {
    return content.contains('<table') || content.contains('<html');
  }

  // ===========================
  // HTML TABLE PARSER
  // ===========================
  List<List<dynamic>> _parseHtmlTable(String content) {
    final document = parse(content);
    final table = document.querySelector('table');
    if (table == null) return [];

    final List<List<dynamic>> rows = [];
    final trList = table.querySelectorAll('tr');

    for (var tr in trList) {
      final cells = tr.querySelectorAll('th, td');
      rows.add(cells.map((e) => e.text.trim()).toList());
    }
    return rows;
  }

  // ===========================
  // BUSINESS LOGIC
  // ===========================
  List<AncRecordModel> _processRows(List<List<dynamic>> rows) {
    List<AncRecordModel> records = [];
    int? headerRowIndex;
    final Map<String, int> columnMap = {};

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

    // 🔍 Detect header row
    for (int i = 0; i < rows.length; i++) {
      final row = rows[i];
      if (row.any((c) => c.toString().toLowerCase().contains('motherid')) &&
          row.any((c) => c.toString().toLowerCase().contains('edd'))) {
        headerRowIndex = i;

        for (int j = 0; j < row.length; j++) {
          final cell = row[j]?.toString().toLowerCase().trim();
          if (expectedColumns.containsKey(cell)) {
            columnMap[expectedColumns[cell]!] = j;
          }
        }
        break;
      }
    }

    if (headerRowIndex == null) return [];

    // 📄 Read data
    for (int i = headerRowIndex + 1; i < rows.length; i++) {
      final row = rows[i];
      if (row.isEmpty) continue;

      String? getVal(String key) {
        final idx = columnMap[key];
        if (idx != null && idx < row.length) {
          return row[idx]?.toString().trim();
        }
        return null;
      }

      if (getVal('ancId') == null && getVal('name') == null) continue;
      
      // Note: serialNumber is optional or auto-inc in db usually, here we parse for reference
      // AncRecordModel doesn't have serialNumber in the V1 model I wrote?
      // Let's check AncRecordModel definition. I did NOT include serialNumber in Step 862 code.
      // That's fine, it's not critical for logic usually.

      records.add(
        AncRecordModel(
          subCentre: getVal('subCentre'),
          ancId: getVal('ancId'),
          name: getVal('name'),
          contactNumber: getVal('contactNumber'),
          edd: _parseDate(getVal('edd')),
          district: getVal('district'),
          phcName: getVal('phc'),
          status: 'Pending',
        ),
      );
    }

    return records;
  }

  // ===========================
  // DATE PARSER
  // ===========================
  DateTime? _parseDate(String? value) {
    if (value == null || value.isEmpty) return null;
    try {
      return DateFormat('dd-MM-yyyy').parse(value);
    } catch (_) {}
    try {
      return DateFormat('dd/MM/yyyy').parse(value);
    } catch (_) {}
    return DateTime.tryParse(value);
  }
}
