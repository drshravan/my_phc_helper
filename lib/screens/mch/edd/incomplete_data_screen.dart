import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_phc_helper/data/models/anc_record_model.dart';
import 'package:my_phc_helper/utils/app_colors.dart';
import 'package:my_phc_helper/widgets/beneficiary_card.dart';

class IncompleteDataScreen extends StatefulWidget {
  final List<AncRecordModel> allRecords;
  final int year;
  final int month;

  const IncompleteDataScreen({
    super.key,
    required this.allRecords,
    required this.year,
    required this.month,
  });

  @override
  State<IncompleteDataScreen> createState() => _IncompleteDataScreenState();
}

class _IncompleteDataScreenState extends State<IncompleteDataScreen> {
  // State for accordion: only one expanded at a time
  String? _expandedSubCenter;

  // Logic identifying incomplete records
  bool isRecordIncomplete(AncRecordModel r) {
    // Basic demographic gaps
    bool missingBasic = (r.village == null || r.village!.isEmpty) ||
                        (r.contactNumber == null || r.contactNumber!.isEmpty) ||
                        (r.husbandName == null || r.husbandName!.isEmpty) ||
                        (r.gravida == null) || 
                        (r.age == null);

    // If delivered but missing delivery info, potentially add here
    // For now sticking to demographics as requested (data filled)
    
    return missingBasic;
  }

  @override
  Widget build(BuildContext context) {
    final date = DateTime(widget.year, widget.month);
    final title = "Data Gaps - ${DateFormat('MMM yyyy').format(date)}";

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? AppColors.backgroundDark : AppColors.background;
    final baseTextColor = isDark ? AppColors.textWhite : AppColors.textDark;

    // Filter
    final incompleteRecords = widget.allRecords.where(isRecordIncomplete).toList();
    
    // Group
    Map<String, List<AncRecordModel>> grouped = {};
    for (var r in incompleteRecords) {
      final sc = r.subCentre?.trim() ?? "Unknown";
      if (!grouped.containsKey(sc)) grouped[sc] = [];
      grouped[sc]!.add(r);
    }
    final sortedKeys = grouped.keys.toList()..sort();

    return Scaffold(
      backgroundColor: baseColor,
      appBar: AppBar(
        title: Column(
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: baseTextColor)),
            Text("${incompleteRecords.length} Records Need Update", style: TextStyle(fontSize: 12, color: Colors.redAccent)),
          ],
        ),
        centerTitle: true,
        backgroundColor: baseColor,
        elevation: 0,
        iconTheme: IconThemeData(color: baseTextColor),
      ),
      body: incompleteRecords.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle, size: 80, color: Colors.green),
                  const SizedBox(height: 16),
                  Text("All Data is Complete!", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: baseTextColor)),
                ],
              ),
            )
          : ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: sortedKeys.length,
              itemBuilder: (context, index) {
                final scName = sortedKeys[index];
                final records = grouped[scName]!;
                final isExpanded = _expandedSubCenter == scName;
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Column(
                    children: [
                      // Header
                      InkWell(
                        onTap: () {
                          setState(() {
                            if (_expandedSubCenter == scName) {
                              _expandedSubCenter = null;
                            } else {
                              _expandedSubCenter = scName;
                            }
                          });
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 6,
                                offset: const Offset(2, 2),
                              ),
                            ],
                            border: isExpanded && isDark ? Border.all(color: Colors.redAccent.withOpacity(0.5)) : null,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isExpanded ? Icons.keyboard_arrow_down_rounded : Icons.keyboard_arrow_right_rounded,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 8),
                              Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  scName, 
                                  style: TextStyle(
                                    fontSize: 16, 
                                    fontWeight: FontWeight.bold, 
                                    color: isExpanded ? Colors.redAccent : AppColors.primaryLight
                                  )
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.redAccent.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "${records.length}", 
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent)
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      // Body (Animated)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: isExpanded ? null : 0,
                        curve: Curves.easeInOut,
                        child: isExpanded 
                          ? Column(
                              children: [
                                const SizedBox(height: 8),
                                ...records.map((r) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0, left: 8, right: 8),
                                  child: BeneficiaryCard(record: r),
                                )).toList(),
                              ],
                            )
                          : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
