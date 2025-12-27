import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_phc_helper/data/models/anc_record_model.dart';
import 'package:my_phc_helper/data/repositories/mch_repository.dart';
import 'package:my_phc_helper/services/excel_export_service.dart';
import 'package:my_phc_helper/screens/mch/edd/incomplete_data_screen.dart';
import 'package:my_phc_helper/screens/mch/edd/sub_center_screen.dart';
import 'package:my_phc_helper/utils/app_colors.dart';
import 'package:my_phc_helper/widgets/dashboard_pie_chart.dart';

class MonthDetailsScreen extends StatefulWidget {
  final int year;
  final int month;

  const MonthDetailsScreen({
    super.key,
    required this.year,
    required this.month,
  });

  @override
  State<MonthDetailsScreen> createState() => _MonthDetailsScreenState();
}

class _MonthDetailsScreenState extends State<MonthDetailsScreen> {
  final MchRepository repo = Get.find<MchRepository>();
  late Stream<List<AncRecordModel>> _recordsStream;
  
  @override
  void initState() {
    super.initState();
    _recordsStream = repo.getRecordsForMonth(widget.year, widget.month);
  }

  // --- Share Logic ---
  void _showShareDialog(BuildContext context, List<AncRecordModel> allRecords) {
    if (allRecords.isEmpty) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Share Excel Report"),
        content: const Text("Choose what you want to share:"),
        actions: [
          // 1. Share Entire PHC Data
          TextButton(
            onPressed: () {
               Get.back();
               _exportData(allRecords, "PHC_Malkapur", null);
            },
            child: const Text("Whole PHC Data"),
          ),
          // 2. Share Specific Sub-Center
          TextButton(
            onPressed: () {
               Get.back();
               _showSubCenterPicker(context, allRecords);
            },
            child: const Text("Sub-Center Data"),
          ),
        ],
      ),
    );
  }

  void _showSubCenterPicker(BuildContext context, List<AncRecordModel> allRecords) {
    // Extract unique SubCenters
    final subCenters = allRecords
        .map((e) => e.subCentre?.trim())
        .where((e) => e != null && e.isNotEmpty)
        .toSet()
        .map((e) => e!)
        .toList();
    subCenters.sort();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Select Sub-Center"),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: subCenters.length,
            itemBuilder: (context, index) {
              final scName = subCenters[index];
              return ListTile(
                title: Text(scName),
                onTap: () {
                   Get.back(); // Close picker
                   final scRecords = allRecords.where((r) => (r.subCentre?.trim() ?? "") == scName).toList();
                   _exportData(scRecords, "SC_$scName", scName);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _exportData(List<AncRecordModel> records, String pfx, String? scName) async {
    final dateStr = DateFormat('MMMM_yyyy').format(DateTime(widget.year, widget.month));
    final filename = "${pfx}_$dateStr";
    
    Get.snackbar("Generating Report", "Creating Excel for ${records.length} records...",
        snackPosition: SnackPosition.BOTTOM, margin: const EdgeInsets.all(16));

    await ExcelExportService.exportAndShare(records, filename, subCenterName: scName);
  }

  // --- Main Build ---
  @override
  Widget build(BuildContext context) {
    final date = DateTime(widget.year, widget.month);
    final title = "PHC Malkapur - ${DateFormat('MMM yyyy').format(date)}";
    
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? AppColors.backgroundDark : AppColors.background;
    final baseTextColor = isDark ? AppColors.textWhite : AppColors.textDark;
    
    final lightShadow = isDark ? AppColors.shadowDarkTop : AppColors.shadowLightTop;
    final darkShadow = isDark ? AppColors.shadowDarkBottom : AppColors.shadowLightBottom;

    return Scaffold(
      backgroundColor: baseColor,
      appBar: AppBar(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: baseTextColor, fontSize: 18)),
        backgroundColor: baseColor,
        elevation: 0,
        iconTheme: IconThemeData(color: baseTextColor),
        centerTitle: true,
        actions: [
          StreamBuilder<List<AncRecordModel>>(
            stream: _recordsStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.isEmpty) return const SizedBox.shrink();
              
              final allRecs = snapshot.data!;
              
              // Warning Count
              int incompleteCount = allRecs.where((r) {
                  bool missing = (r.village == null || r.village!.isEmpty) ||
                                (r.contactNumber == null || r.contactNumber!.isEmpty) ||
                                (r.husbandName == null || r.husbandName!.isEmpty) ||
                                (r.gravida == null) || // Gravida often string or int, check null safely
                                (r.age == null);      // Age check safely
                  return missing;
              }).length;

              return Row(
                children: [
                   if (incompleteCount > 0)
                     Stack(
                      alignment: Alignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
                          onPressed: () {
                             Get.to(() => IncompleteDataScreen(
                               allRecords: allRecs, 
                               year: widget.year, 
                               month: widget.month
                             ));
                          },
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              "$incompleteCount", 
                              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)
                            ),
                          ),
                        )
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.description, color: Colors.green), // Excel icon lookalike
                      tooltip: "Share Excel Report",
                      onPressed: () => _showShareDialog(context, allRecs),
                    ),
                    const SizedBox(width: 8),
                ],
              );
            }
          ),
        ],
      ),
      body: StreamBuilder<List<AncRecordModel>>(
        stream: _recordsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
             return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }
          
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
             return Center(child: Text("No records found", style: TextStyle(color: baseTextColor.withValues(alpha: 0.5))));
          }
          
          final records = snapshot.data!;
          
          // --- Aggregate Stats ---
          int totalRecords = records.length;
          int delivered = records.where((r) => r.status.toLowerCase() == 'delivered').length;
          int aborted = records.where((r) => r.status.toLowerCase() == 'aborted').length;
          int pending = totalRecords - delivered - aborted;
          
          int highRisk = records.where((r) {
             final cause = r.highRiskCause?.trim();
             return (cause != null && cause.isNotEmpty && cause.toLowerCase() != 'no' && cause.toLowerCase() != 'none');
          }).length;

          // --- Group By SubCenter ---
          Map<String, List<AncRecordModel>> groupedRecords = {};
          for (var record in records) {
            final sc = record.subCentre?.trim() ?? "Unknown";
            if (!groupedRecords.containsKey(sc)) groupedRecords[sc] = [];
            groupedRecords[sc]!.add(record);
          }
          final sortedKeys = groupedRecords.keys.toList()..sort();

          return Column(
            children: [
              // 1. FIXED DASHBOARD HEADER (Sticky)
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: baseColor,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(color: lightShadow, offset: const Offset(-8, -8), blurRadius: 16),
                    BoxShadow(color: darkShadow, offset: const Offset(8, 8), blurRadius: 16),
                  ],
                ),
                child: Column(
                  children: [
                    Text("Detailed Overview", 
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: baseTextColor.withValues(alpha: 0.8))
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                         // Chart
                         Expanded(
                           flex: 4,
                           child: DashboardPieChart(
                             pending: pending,
                             delivered: delivered,
                             aborted: aborted,
                             size: 140,
                           ),
                         ),
                         const SizedBox(width: 20),
                         // Key Stats
                         Expanded(
                           flex: 5,
                           child: Column(
                             children: [
                                _buildMiniStatTile("Pending", pending, Colors.orange, isDark),
                                const SizedBox(height: 10),
                                _buildMiniStatTile("Delivered", delivered, Colors.green, isDark),
                                const SizedBox(height: 10),
                                _buildMiniStatTile("Aborted", aborted, Colors.red, isDark),
                             ],
                           ),
                         )
                      ],
                    ),
                    const SizedBox(height: 20),
                    Divider(color: baseTextColor.withValues(alpha: 0.1)),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildBottomStat("Total EDDs", totalRecords, Colors.blue),
                        Container(width: 1, height: 30, color: Colors.grey.withValues(alpha: 0.3)),
                        _buildBottomStat("High Risk", highRisk, Colors.deepPurple),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text("Sub-Centers", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: baseTextColor)),
              ),
              const SizedBox(height: 10),

              // 2. SCROLLABLE SUB-CENTER LIST
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
                  itemCount: sortedKeys.length, 
                  itemBuilder: (context, index) {
                    final scName = sortedKeys[index];
                    final scRecords = groupedRecords[scName]!;
                    return _buildSubCentreCard(context, scName, scRecords, baseColor, lightShadow, darkShadow, baseTextColor);
                  },
                ),
              ),
            ],
          );
        }
      ),
    );
  }

  Widget _buildMiniStatTile(String label, int value, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 4, backgroundColor: color),
              const SizedBox(width: 8),
              Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isDark ? Colors.white70 : Colors.black87)),
            ],
          ),
          Text("$value", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildBottomStat(String label, int value, Color color) {
    return Column(
      children: [
        Text("$value", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  // SubCentre Card with Stats
  Widget _buildSubCentreCard(
    BuildContext context,
    String scName, 
    List<AncRecordModel> records, 
    Color baseColor, 
    Color lightShadow, 
    Color darkShadow,
    Color textColor
  ) {
    // SC Specific Stats
    int pending = 0;
    int delivered = 0;
    int aborted = 0;

    for (var r in records) {
       final s = r.status.toLowerCase();
       if (s == 'delivered') delivered++;
       else if (s == 'aborted') aborted++;
       else pending++;
    }

    return GestureDetector(
      onTap: () {
        // Navigate to Drill-Down Screen
        Get.to(() => SubCenterScreen(
          year: widget.year,
          month: widget.month,
          subCenterName: scName,
        ));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: lightShadow, offset: const Offset(-4, -4), blurRadius: 10),
            BoxShadow(color: darkShadow.withValues(alpha: 0.4), offset: const Offset(4, 4), blurRadius: 10),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    scName,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primaryLight),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(Icons.chevron_right, color: textColor.withValues(alpha: 0.3)),
              ],
            ),
            const SizedBox(height: 16),
            // Mini Dashboard for SC
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                 _buildScStat("Total", records.length, Colors.blue),
                 _buildScStat("Pending", pending, Colors.orange),
                 _buildScStat("Delivered", delivered, Colors.green),
                 _buildScStat("Aborted", aborted, Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScStat(String label, int val, Color color) {
    bool isZero = val == 0;
    return Column(
      children: [
        Text("$val", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isZero ? color.withValues(alpha: 0.5) : color)),
         Text(label, style: TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }
}
