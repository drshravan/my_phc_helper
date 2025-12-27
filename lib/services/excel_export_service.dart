import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:my_phc_helper/data/models/anc_record_model.dart';
import 'package:cross_file/cross_file.dart';

class ExcelExportService {
  
  /// Generates an Excel file for the given records and shares it.
  static Future<void> exportAndShare(
    List<AncRecordModel> records, 
    String fileNamePrefix, 
    {String? subCenterName}
  ) async {
    // 1. Create a WorkBook
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    
    // 2. Set Header Title
    String title = subCenterName != null 
        ? "ANC List - $subCenterName" 
        : "PHC Malkapur Monthly ANC List";
        
    sheet.getRangeByName('A1').setText(title);
    sheet.getRangeByName('A1:L1').merge();
    sheet.getRangeByName('A1').cellStyle.bold = true;
    sheet.getRangeByName('A1').cellStyle.hAlign = HAlignType.center;

    // 3. Define Headers
    final List<String> headers = [
      "Si.No", "RCH ID", "Beneficiary Name", "Husband Name", 
      "Age", "Gravida", "Parity", "LMP", "EDD", 
      "Mobile", "Village", "Sub Center", "Status", "Delivery Details"
    ];

    for (int i = 0; i < headers.length; i++) {
      sheet.getRangeByIndex(2, i + 1).setText(headers[i]);
      sheet.getRangeByIndex(2, i + 1).cellStyle.bold = true;
      sheet.getRangeByIndex(2, i + 1).cellStyle.backColor = '#E0E0E0';
    }

    // 4. Fill Data
    int rowIndex = 3;
    for (int i = 0; i < records.length; i++) {
      var r = records[i];
      
      sheet.getRangeByIndex(rowIndex, 1).setNumber((i + 1).toDouble());
      sheet.getRangeByIndex(rowIndex, 2).setText(r.ancId ?? "-");
      sheet.getRangeByIndex(rowIndex, 3).setText(r.name ?? "-");
      sheet.getRangeByIndex(rowIndex, 4).setText(r.husbandName ?? "-");
      sheet.getRangeByIndex(rowIndex, 5).setText(r.age?.toString() ?? "-");
      sheet.getRangeByIndex(rowIndex, 6).setText(r.gravida?.toString() ?? "-");
      sheet.getRangeByIndex(rowIndex, 7).setText("-"); // Parity not in model
      sheet.getRangeByIndex(rowIndex, 8).setText(r.lmp != null ? DateFormat('dd-MM-yyyy').format(r.lmp!) : "-");
      sheet.getRangeByIndex(rowIndex, 9).setText(r.edd != null ? DateFormat('dd-MM-yyyy').format(r.edd!) : "-");
      sheet.getRangeByIndex(rowIndex, 10).setText(r.contactNumber ?? "-");
      sheet.getRangeByIndex(rowIndex, 11).setText(r.village ?? "-");
      sheet.getRangeByIndex(rowIndex, 12).setText(r.subCentre ?? "-");
      sheet.getRangeByIndex(rowIndex, 13).setText(r.status);
      
      String delivery = "";
      if (r.status.toLowerCase() == 'delivered') {
        delivery = "${r.deliveryDate != null ? DateFormat('dd-MM-yyyy').format(r.deliveryDate!) : ''} (${r.deliveryMode ?? ''})";
      } else if (r.status.toLowerCase() == 'aborted') {
         delivery = "Aborted";
      }
      sheet.getRangeByIndex(rowIndex, 14).setText(delivery);
      
      rowIndex++;
    }

    // Auto-fit columns
    for (int i = 1; i <= headers.length; i++) {
      sheet.autoFitColumn(i);
    }

    // 5. Save Bytes
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    // 6. Share using XFile.fromData (Web Compatible)
    // mimeType for .xlsx is application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
    final xfile = XFile.fromData(
      Uint8List.fromList(bytes), 
      name: "$fileNamePrefix.xlsx",
      mimeType: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
    );

    await Share.shareXFiles(
      [xfile],
      text: "Here is the Excel data for $title.",
    );
  }
}
