import 'dart:io';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';

void main() {
  final path =
      "d:\\My Projects\\Flutter Projects\\my_phc_helper\\January - 2025_12_24 20_56_41.xls";
  print("Attempting to parse: $path");

  try {
    final file = File(path);
    if (!file.existsSync()) {
      print("File does not exist!");
      return;
    }

    final bytes = file.readAsBytesSync();
    print("Read ${bytes.length} bytes.");

    final decoder = SpreadsheetDecoder.decodeBytes(bytes);
    print("Decoded successfully. Tables: ${decoder.tables.keys}");

    for (var table in decoder.tables.keys) {
      print("Table: $table, Rows: ${decoder.tables[table]!.rows.length}");
      // Print first few rows to verify content
      for (var i = 0; i < 3 && i < decoder.tables[table]!.rows.length; i++) {
        print("Row $i: ${decoder.tables[table]!.rows[i]}");
      }
    }
  } catch (e, stack) {
    print("Error parsing excel: $e");
    print(stack);
  }
}
