import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_phc_helper/data/database/database.dart';
import 'package:my_phc_helper/data/repositories/anc_repository.dart';
import 'package:my_phc_helper/utils/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'edd_details_screen.dart';

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
  final AncRepository repo = Get.find<AncRepository>();
  Map<String, List<AncRecord>> groupedRecords = {};
  final List<ExpansibleController> _controllers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final all = await repo.getAllAncRecords();
    final filtered = all.where((r) => 
      r.edd != null && 
      r.edd!.year == widget.year && 
      r.edd!.month == widget.month
    ).toList();
    
    // Sort by EDD date first
    filtered.sort((a, b) => a.edd!.compareTo(b.edd!));

    // Group by SubCentre
    Map<String, List<AncRecord>> groups = {};
    for (var record in filtered) {
      final sc = record.subCentre?.trim() ?? "Unknown";
      if (!groups.containsKey(sc)) {
        groups[sc] = [];
      }
      groups[sc]!.add(record);
    }

    // Initialize controllers for accordion
    _controllers.clear();
    for (var _ in groups.keys) {
      _controllers.add(ExpansibleController());
    }

    setState(() {
      groupedRecords = groups;
      isLoading = false;
    });
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      Get.snackbar("Error", "Could not dial $phoneNumber");
    }
  }

  void _onTileExpanded(int index) {
    for (int i = 0; i < _controllers.length; i++) {
      if (i != index) {
        _controllers[i].collapse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final date = DateTime(widget.year, widget.month);
    final title = DateFormat('MMMM yyyy').format(date);
    
    // Theme & Neumorphic Colors
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? const Color(0xFF2E3239) : const Color(0xFFEFF3F6);
    final baseTextColor = isDark ? Colors.white70 : Colors.black87;
    // Shadows: Light mode (White highlight, dark grey shadow). Dark mode (Lighter grey highlight, Black shadow)
    final lightShadow = isDark ? const Color(0xFF353941) : Colors.white;
    final darkShadow = isDark ? const Color(0xFF23262C) : const Color(0xFFA6B0C3);

    return Scaffold(
      backgroundColor: baseColor,
      appBar: AppBar(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: baseTextColor)),
        backgroundColor: baseColor,
        elevation: 0,
        iconTheme: IconThemeData(color: baseTextColor),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: AppColors.primary))
          : groupedRecords.isEmpty 
              ? Center(child: Text("No records found", style: TextStyle(color: baseTextColor.withValues(alpha: 0.5))))
              : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: groupedRecords.keys.length,
              itemBuilder: (context, index) {
                final scName = groupedRecords.keys.elementAt(index);
                final records = groupedRecords[scName]!;
                return _buildSubCentreTile(
                  scName, 
                  records, 
                  index, 
                  baseColor, 
                  lightShadow, 
                  darkShadow, 
                  baseTextColor
                );
              },
            ),
    );
  }

  Widget _buildSubCentreTile(
    String scName, 
    List<AncRecord> records, 
    int index, 
    Color baseColor, 
    Color lightShadow, 
    Color darkShadow,
    Color textColor
  ) {
    // Calc stats for this group
    int normal = 0, lscs = 0, abortion = 0, govt = 0, pvt = 0;
    for (var r in records) {
      final mode = r.deliveryMode?.toLowerCase() ?? '';
      if (mode.contains('normal')) {
        normal++;
      } else if (mode.contains('lscs') || mode.contains('c-section')) {
        lscs++;
      } else if (mode.contains('abortion')) {
        abortion++;
      }

      final place = r.deliveryAddress?.toLowerCase() ?? '';
      if (place.contains('govt') || place.contains('phc')) {
        govt++;
      } else if (place.contains('pvt') || place.contains('hosp')) {
        pvt++;
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: lightShadow, offset: const Offset(-4, -4), blurRadius: 10),
          BoxShadow(color: darkShadow.withValues(alpha: 0.4), offset: const Offset(4, 4), blurRadius: 10),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: _controllers[index],
          onExpansionChanged: (isOpen) {
            if (isOpen) _onTileExpanded(index);
          },
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          title: Text(
            scName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          trailing: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: baseColor,
              shape: BoxShape.circle,
              boxShadow: [
                 BoxShadow(color: lightShadow, offset: const Offset(-2, -2), blurRadius: 4),
                 BoxShadow(color: darkShadow.withValues(alpha: 0.2), offset: const Offset(2, 2), blurRadius: 4),
              ],
            ),
            child: Text(
              "${records.length}",
              style: TextStyle(fontWeight: FontWeight.bold, color: textColor.withValues(alpha: 0.7)),
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              children: [
                _buildMiniStat("N", "$normal", Colors.green, baseColor, lightShadow, darkShadow),
                const SizedBox(width: 8),
                _buildMiniStat("L", "$lscs", Colors.orange, baseColor, lightShadow, darkShadow),
                const SizedBox(width: 8),
                _buildMiniStat("A", "$abortion", Colors.red, baseColor, lightShadow, darkShadow),
                const Spacer(),
                 _buildMiniStat("G", "$govt", Colors.blue, baseColor, lightShadow, darkShadow),
                const SizedBox(width: 8),
                _buildMiniStat("P", "$pvt", Colors.purple, baseColor, lightShadow, darkShadow),
              ],
            ),
          ),
          children: records.map((r) => _buildMemberItem(r, baseColor, lightShadow, darkShadow, textColor)).toList(),
        ),
      ),
    );
  }

  Widget _buildMiniStat(String label, String count, Color color, Color base, Color light, Color dark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: base,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
             BoxShadow(color: light, offset: const Offset(-1, -1), blurRadius: 2),
             BoxShadow(color: dark.withValues(alpha: 0.2), offset: const Offset(1, 1), blurRadius: 2),
        ],
      ),
      child: Row(
        children: [
          Text(label, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold)),
          const SizedBox(width: 4),
          Text(count, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color.withValues(alpha: 0.8))),
        ],
      ),
    );
  }

  Widget _buildMemberItem(AncRecord record, Color base, Color light, Color dark, Color textColor) {
    bool isHighRisk = (record.highRiskCause != null && record.highRiskCause!.isNotEmpty);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: base,
        borderRadius: BorderRadius.circular(12),
        // Inner shadow for list items
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [base, base],
        ),
        boxShadow: [
          BoxShadow(color: light, offset: const Offset(-2, -2), blurRadius: 5),
          BoxShadow(color: dark.withValues(alpha: 0.2), offset: const Offset(2, 2), blurRadius: 5),
        ],
      ),
      child: InkWell(
        onTap: () => Get.to(() => EddDetailsScreen(record: record)),
        child: Row(
          children: [
            // Gravida Circle
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: base,
                shape: BoxShape.circle,
                boxShadow: isHighRisk ? [
                   BoxShadow(color: AppColors.error.withValues(alpha: 0.3), offset: const Offset(2, 2), blurRadius: 4),
                ] : [
                   BoxShadow(color: light, offset: const Offset(-2, -2), blurRadius: 4),
                   BoxShadow(color: dark.withValues(alpha: 0.2), offset: const Offset(2, 2), blurRadius: 4),
                ],
              ),
              child: Center(
                child: Text(
                  record.gravida?.toString() ?? "G",
                  style: TextStyle(
                    color: isHighRisk ? AppColors.error : AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    record.name ?? "Unknown",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 12, color: textColor.withValues(alpha: 0.6)),
                      const SizedBox(width: 4),
                      Text(
                        record.edd != null ? DateFormat('dd MMM').format(record.edd!) : 'N/A',
                        style: TextStyle(fontSize: 13, color: textColor.withValues(alpha: 0.6)),
                      ),
                      const SizedBox(width: 12),
                      if (isHighRisk)
                        Expanded(
                          child: Text(
                            "${record.highRiskCause}",
                            style: const TextStyle(color: AppColors.error, fontSize: 11, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            // Call Button
            if (record.contactNumber != null && record.contactNumber!.isNotEmpty)
              InkWell(
                onTap: () => makePhoneCall(record.contactNumber!),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: base,
                    shape: BoxShape.circle,
                    boxShadow: [
                       BoxShadow(color: light, offset: const Offset(-2, -2), blurRadius: 4),
                       BoxShadow(color: dark.withValues(alpha: 0.2), offset: const Offset(2, 2), blurRadius: 4),
                    ],
                  ),
                  child: const Icon(Icons.phone, color: Colors.green, size: 20),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
