import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_phc_helper/data/database/database.dart';
import 'package:my_phc_helper/data/repositories/anc_repository.dart';
import 'package:my_phc_helper/services/excel_service.dart';
import 'package:my_phc_helper/utils/app_colors.dart';

class EntriesTab extends StatefulWidget {
  const EntriesTab({super.key});

  @override
  State<EntriesTab> createState() => _EntriesTabState();
}

class _EntriesTabState extends State<EntriesTab> {
  final ExcelService excelService = ExcelService();
  final AncRepository repo = Get.find<AncRepository>();
  final TextEditingController pasteController = TextEditingController();
  
  List<AncRecordsCompanion> previewRecords = [];

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
         Get.snackbar("Error", "No valid records found in pasted text.");
         return;
      }

      setState(() {
        previewRecords = records;
      });

    } catch (e) {
      Get.back(); // close loader
      Get.snackbar(
        "Error",
        "Failed to parse data: $e",
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _confirmImport() async {
     try {
      Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
      
      for (var record in previewRecords) {
        await repo.insertAncRecord(record);
      }
      
      Get.back(); // close loader
      
      setState(() {
        previewRecords = [];
        pasteController.clear();
      });
      
      Get.snackbar(
        "Success",
        "Imported ${previewRecords.length} records successfully!",
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
    return Scaffold(
      body: previewRecords.isNotEmpty ? _buildPreviewUI() : _buildPasteUI(),
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
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
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
                  "Found ${previewRecords.length} records. Please review before importing.",
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
                title: Text(record.name.value ?? "Unknown"),
                subtitle: Text("ID: ${record.ancId.value} | EDD: ${record.edd.value?.toString().split(' ')[0]}"),
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
