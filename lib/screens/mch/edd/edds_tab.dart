import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_phc_helper/data/models/stats_models.dart';
import 'package:my_phc_helper/data/repositories/mch_repository.dart';
import 'package:my_phc_helper/utils/app_colors.dart';
import 'month_details_screen.dart';
import 'month_stat_tile.dart';

class EddsTab extends StatefulWidget {
  const EddsTab({super.key});

  @override
  State<EddsTab> createState() => _EddsTabState();
}

class _EddsTabState extends State<EddsTab> {
  final MchRepository _repo = Get.find<MchRepository>();
  
  List<MonthStats> _monthStats = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() async {
    setState(() => _isLoading = true);
    try {
      final stats = await _repo.getAggregatedMonths();
      if (mounted) {
        setState(() {
          _monthStats = stats;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
      
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
               TextButton(onPressed: () {
                 Get.back();
                 _refreshData(); // Retry
               }, child: const Text("I have updated the rules")),
            ],
          ),
          barrierDismissible: false,
        );
      } else {
        Get.snackbar("Error", "Failed to load data: $e", backgroundColor: AppColors.error);
      }
    }
  }

  static const String _staticPin = "1234";

  Future<void> _deleteMonth(int year, int month) async {
    final dateStr = DateFormat('MMMM yyyy').format(DateTime(year, month));
    
    // 1. Confirm Intent
    final bool? confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text("Delete Records"),
        content: Text("Are you sure you want to delete ALL records for $dateStr? \n\nThis action cannot be undone."),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () => Get.back(result: true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    // 2. Verify PIN
    final bool pinVerified = await _verifyPin("Enter PIN to confirm deletion for '$dateStr'.");
    
    if (pinVerified) {
       await _repo.deleteRecordsForMonth(year, month);
       Get.snackbar("Success", "Deleted records for $dateStr", backgroundColor: AppColors.success, colorText: Colors.white);
       _refreshData();
    }
  }

  Future<bool> _verifyPin(String message) async {
    final TextEditingController verifyController = TextEditingController();
    bool? result = await Get.dialog<bool>(
      AlertDialog(
        title: const Text("Security Check"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message),
            const SizedBox(height: 16),
            TextField(
              controller: verifyController,
              keyboardType: TextInputType.number,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Enter PIN",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
               if (verifyController.text == _staticPin) {
                 Get.back(result: true);
               } else {
                 Get.snackbar("Error", "Incorrect PIN");
               }
            },
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_monthStats.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today, size: 60, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            const Text(
              "No Data Available",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 8),
             const Text(
              "Go to 'Entries' tab to import data.",
              style: TextStyle(color: Colors.grey),
            ),
           ],
        ),
      );
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async => _refreshData(),
        child: ListView.builder(
          itemCount: _monthStats.length,
          padding: const EdgeInsets.only(bottom: 80, top: 16),
          itemBuilder: (context, index) {
            final stat = _monthStats[index];
            return MonthStatTile(
              stats: stat,
              onTap: () {
                Get.to(() => MonthDetailsScreen(
                  year: stat.year,
                  month: stat.month,
                ));
              },
              onLongPress: () => _deleteMonth(stat.year, stat.month),
            );
          },
        ),
      ),
    );
  }
}
