import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_phc_helper/data/models/anc_record_model.dart';
import 'package:my_phc_helper/data/repositories/mch_repository.dart';
import 'package:my_phc_helper/services/excel_service.dart';
import 'package:my_phc_helper/utils/app_colors.dart';
import 'package:my_phc_helper/widgets/neumorphic_container.dart';
import 'package:my_phc_helper/widgets/advanced_pin_input.dart';

class EntriesTab extends StatefulWidget {
  const EntriesTab({super.key});

  @override
  State<EntriesTab> createState() => _EntriesTabState();
}

class _EntriesTabState extends State<EntriesTab> {
  final ExcelService excelService = ExcelService();
  final MchRepository repo = Get.find<MchRepository>();
  final TextEditingController pasteController = TextEditingController();

  bool _isUnlocked = false;
  List<AncRecordModel> previewRecords = [];
  
  // Security PIN
  static const String _staticPin = "1234";



  Future<void> _processPaste() async {
    final text = pasteController.text;
    if (text.isEmpty) {
      Get.snackbar("Info", "Please paste some data first");
      return;
    }

    try {
      Get.dialog(const Center(child: CircularProgressIndicator()),
          barrierDismissible: false);

      final records = await excelService.parsePasteData(text);
      Get.back(); // close loader

      if (records.isEmpty) {
         Get.snackbar("Error", "No valid records found.");
         return;
      }

      // 1. Identify Month/Year from the first record (Assumption: Batch is for one month)
      final firstEdd = records.first.edd;
      if (firstEdd != null) {
        final year = firstEdd.year;
        final month = firstEdd.month;
        
        // 2. Check for existing data & Prepare Merge
        // Fetch existing records once to check against
        final existingRecords = await repo.getRecordsForMonth(year, month).first;
        
        // Map existing records by ANC ID for fast lookup
        final existingMap = {for (var r in existingRecords) r.ancId?.trim().toLowerCase(): r};
        
        
        // 3. Apply Merge Logic
        // int newCount = 0; // Unused
        int updateCount = 0;

        for (var newRecord in records) {
           final key = newRecord.ancId?.trim().toLowerCase();
           
           if (key != null && existingMap.containsKey(key)) {
             // MATCH FOUND: Preserve ID and Status
             final existing = existingMap[key]!;
             newRecord.id = existing.id;
             newRecord.status = existing.status; // Keep existing status (e.g. Delivered)
             
             // Preserve other critical manual fields to be safe
             newRecord.deliveryDate = existing.deliveryDate;
             newRecord.deliveryMode = existing.deliveryMode;
             newRecord.babyGender = existing.babyGender;
             
             updateCount++;
           } 
           // else { new record }
        }
        
        // Auto-proceed to preview (no blocking conflict dialog anymore)
        // Just show a distinct snackbar if merging
        if (updateCount > 0) {
           Get.snackbar("Merge Mode", "Found $updateCount existing records. Their status will be preserved.", 
             backgroundColor: AppColors.secondary, colorText: Colors.white, duration: const Duration(seconds: 4));
        }
      }

      setState(() {
        previewRecords = records;
      });

    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();
      
      String errorMsg = "Failed to parse: $e";
      if (e.toString().contains("permission-denied")) {
        // Show Blocking Dialog
        Get.dialog(
          AlertDialog(
            title: const Text("Database Access Denied", style: TextStyle(color: Colors.red)),
            content: const SizedBox(
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text("The app is blocked by Firebase Security Rules.", style: TextStyle(fontWeight: FontWeight.bold)),
                   SizedBox(height: 16),
                   Text("Action Required:", style: TextStyle(fontWeight: FontWeight.w600)),
                   Text("1. Open Firebase Console"),
                   Text("2. Go to Firestore Database > Rules"),
                   Text("3. Change 'allow read, write: if false;' to:"),
                   SizedBox(height: 8),
                   SelectableText(
                     "allow read, write: if true;", 
                     style: TextStyle(fontFamily: 'monospace', backgroundColor: Colors.yellowAccent),
                   ),
                   SizedBox(height: 8),
                   Text("4. Click Publish"),
                ],
              ),
            ),
            actions: [
               TextButton(onPressed: () => Get.back(), child: const Text("I have updated the rules")),
               ElevatedButton(
                 onPressed: () => Get.back(), 
                 child: const Text("Close")
               ),
            ],
          ),
          barrierDismissible: false,
        );
        return; // Don't show snackbar
      }
      
      Get.snackbar(
        "Error", 
        errorMsg, 
        backgroundColor: AppColors.error, 
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
    }
  }



  Future<void> _confirmImport() async {
     try {
      Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
      
      // Use Batch Write to save Firestore quota and improve speed
      await repo.batchAddAncRecords(previewRecords);
      
      Get.back(); // close loader
      
      setState(() {
        previewRecords = [];
        pasteController.clear();
      });
      
      Get.snackbar(
        "Success",
        "Imported records successfully!",
        backgroundColor: AppColors.success,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.back();
      Get.snackbar("Error", "Failed to save: $e", backgroundColor: AppColors.error);
    }
  }

  void _cancelPreview() {
    setState(() {
      previewRecords = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isUnlocked) {
      return _buildLockScreen();
    }
    return Scaffold(
      body: previewRecords.isNotEmpty ? _buildPreviewUI() : _buildPasteUI(),
    );
  }

  Widget _buildLockScreen() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock, size: 64, color: isDark ? Colors.white70 : Colors.grey),
              const SizedBox(height: 24),
              const Text("Restricted Access", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text("Enter PIN to access Data Entry", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 24),
              SizedBox(
                width: 280, // Wider for 4 boxes
                child: AdvancedPinInput(
                  length: 4,
                  onCompleted: (pin) {
                    if (pin == _staticPin) {
                      setState(() {
                         _isUnlocked = true;
                      });
                    } else {
                       // Optional: Clear fields or shake? 
                       // For now just snackbar
                       Get.snackbar("Error", "Incorrect PIN", backgroundColor: AppColors.error, colorText: Colors.white);
                    }
                  },
                ),
              ),

              // Button removed as AdvancedPinInput handles auto-completion
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasteUI() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Import Data via Copy-Paste",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "1. Open your Excel file (XLS or XLSX).\n"
            "2. Select the rows you want to import (including headers).\n"
            "3. Copy them (Ctrl+C).\n"
            "4. Paste them below (Ctrl+V).",
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: NeumorphicContainer(
               padding: EdgeInsets.zero,
               borderRadius: BorderRadius.circular(12),
               child: TextField(
                controller: pasteController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(16),
                  border: InputBorder.none,
                  hintText: "Paste your Excel data here...",
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _processPaste,
            icon: const Icon(Icons.preview),
            label: const Text("Preview Data"),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewUI() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: AppColors.primary.withValues(alpha: 0.1),
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: AppColors.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Found ${previewRecords.length} records. Ready to import.",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            itemCount: previewRecords.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final record = previewRecords[index];
              return ListTile(
                leading: CircleAvatar(child: Text("${index + 1}")),
                title: Text(record.name ?? "Unknown"),
                subtitle: Text("ID: ${record.ancId} | EDD: ${DateFormat('dd-MM-yyyy').format(record.edd!)}"),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _cancelPreview,
                  style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                  child: const Text("Cancel"),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _confirmImport,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text("Confirm Import"),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
