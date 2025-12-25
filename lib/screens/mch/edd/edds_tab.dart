import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:my_phc_helper/data/database/database.dart';
import 'package:my_phc_helper/data/repositories/anc_repository.dart';
import 'package:my_phc_helper/services/excel_service.dart';
import 'package:my_phc_helper/utils/app_colors.dart';
import 'package:intl/intl.dart';
import 'edd_details_screen.dart';
import 'dart:io' as java_io;

class EddsTab extends StatefulWidget {
  const EddsTab({super.key});

  @override
  State<EddsTab> createState() => _EddsTabState();
}

class _EddsTabState extends State<EddsTab> {
  final AncRepository _repo = Get.find<AncRepository>();
  final ExcelService _excelService = ExcelService();
  final TextEditingController _searchController = TextEditingController();

  List<AncRecord> _allRecords = [];
  List<AncRecord> _filteredRecords = [];

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() async {
    final records = await _repo.getAllAncRecords();
    setState(() {
      _allRecords = records;
      _filteredRecords = records;
    });
  }

  void _filter(String query) {
    if (query.isEmpty) {
      setState(() => _filteredRecords = _allRecords);
      return;
    }
    setState(() {
      _filteredRecords = _allRecords.where((r) {
        return (r.name?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
            (r.village?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
            (r.subCentre?.toLowerCase().contains(query.toLowerCase()) ??
                false) ||
            (r.contactNumber?.contains(query) ?? false);
      }).toList();
    });
  }

  Future<void> _pickAndUploadExcel() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xls', 'xlsx'],
    );

    if (result != null) {
      try {
        Get.dialog(const Center(child: CircularProgressIndicator()));

        List<AncRecordsCompanion> records;

        // On Web, bytes are available directly
        if (result.files.single.bytes != null) {
          records = await _excelService.parseExcel(result.files.single.bytes!);
        } else if (result.files.single.path != null) {
          // On Mobile/Desktop, read from path
          final file = java_io.File(result.files.single.path!);
          final bytes = await file.readAsBytes();
          records = await _excelService.parseExcel(bytes);
        } else {
          throw Exception("No file data available");
        }

        for (var record in records) {
          await _repo.insertAncRecord(record);
        }
        Get.back(); // Close loader
        _refreshData();
        Get.snackbar(
          "Success",
          "Imported ${records.length} records",
          backgroundColor: AppColors.success,
          colorText: Colors.white,
        );
      } catch (e) {
        Get.back(); // Close loader
        String errorMessage = "Failed to parse file: $e";
        
        // Remove "Exception:" prefix from cleaner error messages
        if (e.toString().contains("Exception: ")) {
          errorMessage = e.toString().replaceAll("Exception: ", "");
        } else if (e.toString().contains("End of Central Directory")) {
          errorMessage = "Invalid file format. Please upload a valid .xlsx or .xls file.";
        }
        
        Get.snackbar(
          "Error",
          errorMessage,
          backgroundColor: AppColors.error,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _pickAndUploadExcel,
        label: const Text("Upload Excel"),
        icon: const Icon(Icons.upload_file),
        backgroundColor: AppColors.secondary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filter,
              decoration: InputDecoration(
                hintText: "Search Name, Village, Mobile...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _filter('');
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredRecords.length,
              padding: const EdgeInsets.only(bottom: 80),
              itemBuilder: (context, index) {
                final record = _filteredRecords[index];
                return _buildListItem(record);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(AncRecord record) {
    bool isHighRisk =
        (record.highRiskCause != null && record.highRiskCause!.isNotEmpty);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: isHighRisk
              ? AppColors.error.withValues(alpha: 0.2)
              : AppColors.primary.withValues(alpha: 0.1),
          child: Text(
            record.gravida?.toString() ?? "G",
            style: TextStyle(
              color: isHighRisk ? AppColors.error : AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          record.name ?? "Unknown",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              "EDD: ${record.edd != null ? DateFormat('dd MMM yyyy').format(record.edd!) : 'N/A'}",
            ),
            Text(
              "Village: ${record.village ?? 'N/A'} | SubCentre: ${record.subCentre ?? 'N/A'}",
            ),
            if (isHighRisk)
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  "HR: ${record.highRiskCause}",
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
          ],
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
        onTap: () {
          Get.to(() => EddDetailsScreen(record: record));
        },
      ),
    );
  }
}
