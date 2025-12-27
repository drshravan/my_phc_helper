import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_phc_helper/data/models/anc_record_model.dart';
import 'package:my_phc_helper/data/repositories/mch_repository.dart';
import 'package:my_phc_helper/utils/app_colors.dart';
import 'package:my_phc_helper/widgets/beneficiary_card.dart';

class SubCenterScreen extends StatefulWidget {
  final int year;
  final int month;
  final String subCenterName;

  const SubCenterScreen({
    super.key,
    required this.year,
    required this.month,
    required this.subCenterName,
  });

  @override
  State<SubCenterScreen> createState() => _SubCenterScreenState();
}

class _SubCenterScreenState extends State<SubCenterScreen> {
  final MchRepository repo = Get.find<MchRepository>();
  final PageController _pageController = PageController();
  late Stream<List<AncRecordModel>> _recordsStream;
  int _selectedIndex = 0;
  
  @override
  void initState() {
    super.initState();
    // Initialize stream ONCE
    _recordsStream = repo.getRecordsForMonth(widget.year, widget.month);
  }
  
  void _onTabSelected(int index) {
    if (_selectedIndex == index) return;
    
    setState(() => _selectedIndex = index);
    if (_pageController.hasClients) {
      _pageController.animateToPage(
        index, 
        duration: const Duration(milliseconds: 300), 
        curve: Curves.easeInOut
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Format Title: "SubCenter Name - Jan 2026"
    final date = DateTime(widget.year, widget.month);
    final monthStr = DateFormat('MMM yyyy').format(date);
    final title = "${widget.subCenterName}\n$monthStr"; // Two lines if needed or one

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? AppColors.backgroundDark : AppColors.background;
    final baseTextColor = isDark ? AppColors.textWhite : AppColors.textDark;
    
    final lightShadow = isDark ? AppColors.shadowDarkTop : AppColors.shadowLightTop;
    final darkShadow = isDark ? AppColors.shadowDarkBottom : AppColors.shadowLightBottom;

    return Scaffold(
      backgroundColor: baseColor,
      appBar: AppBar(
        title: Text(title, 
          style: TextStyle(fontWeight: FontWeight.bold, color: baseTextColor, fontSize: 18),
          textAlign: TextAlign.center,
        ),
        backgroundColor: baseColor,
        elevation: 0,
        iconTheme: IconThemeData(color: baseTextColor),
        centerTitle: true,
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
          
          // FILTER BY SUB-CENTER
          // Normalize matching (trim + lowercase usually safe, but display name passed might be clean)
          // We'll try exact match first, or flexible.
          final allRecords = snapshot.data!;
          final records = allRecords.where((r) => 
            (r.subCentre?.trim() ?? "Unknown") == widget.subCenterName
          ).toList();

          if (records.isEmpty) {
             return Center(child: Text("No records for ${widget.subCenterName}", style: TextStyle(color: baseTextColor)));
          }
          
          // Calculate Totals for this SC
          int totalRecords = records.length;
          int totalDelivered = records.where((r) => r.status.toLowerCase() == 'delivered').length;
          int totalAborted = records.where((r) => r.status.toLowerCase() == 'aborted').length;
          int pending = totalRecords - totalDelivered - totalAborted;

          return Column(
            children: [
               // Interactive Tab Bar (Pending, Delivered, Aborted, Total)
               Container(
                 padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                 margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                 decoration: BoxDecoration(
                   color: baseColor,
                   borderRadius: BorderRadius.circular(20),
                   boxShadow: [
                     BoxShadow(color: lightShadow, offset: const Offset(-4, -4), blurRadius: 10),
                     BoxShadow(color: darkShadow, offset: const Offset(4, 4), blurRadius: 10),
                   ],
                 ),
                 child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildTabItem(0, "Pending", "$pending", Colors.orange, baseTextColor, context),
                      _buildTabItem(1, "Delivered", "$totalDelivered", Colors.green, baseTextColor, context),
                      _buildTabItem(2, "Aborted", "$totalAborted", Colors.red, baseTextColor, context),
                      _buildTabItem(3, "Total", "$totalRecords", Colors.blue, baseTextColor, context),
                    ],
                 ),
               ),
               
               // PageView Body
               Expanded(
                 child: PageView(
                   controller: _pageController,
                   physics: const BouncingScrollPhysics(),
                   onPageChanged: (index) => setState(() => _selectedIndex = index),
                   children: [
                     // 0: Pending
                     _buildFlatList(records.where((r) => r.status.toLowerCase() != 'delivered' && r.status.toLowerCase() != 'aborted').toList(), "Pending"), 
                     // 1: Delivered
                     _buildFlatList(records.where((r) => r.status.toLowerCase() == 'delivered').toList(), "Delivered"), 
                     // 2: Aborted
                     _buildFlatList(records.where((r) => r.status.toLowerCase() == 'aborted').toList(), "Aborted"), 
                     // 3: Total (Flat list for SC view, not grouped)
                     _buildFlatList(records, "Total"), 
                   ],
                 ),
               ),
            ],
          );
        }
      ),
    );
  }

  Widget _buildTabItem(int index, String label, String value, Color color, Color textColor, BuildContext context) {
    bool isSelected = _selectedIndex == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: () => _onTabSelected(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: isSelected 
            ? BoxDecoration(
                color: isDark ? const Color(0xFF252525) : const Color(0xFFE0E5EC),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: color.withValues(alpha: 0.6), 
                  width: 1.5
                ),
                // Emulate pressed look via flat color + border vs raised shadow
              ) 
            : BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(16),
            ),
        child: Column(
          children: [
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: isSelected ? 24 : 18, 
                fontWeight: FontWeight.bold, 
                color: isSelected ? color : color.withValues(alpha: 0.6)
              ),
              child: Text(value),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 12, 
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? textColor : textColor.withValues(alpha: 0.5)
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlatList(List<AncRecordModel> filteredRecords, String emptyTitle) {
    if (filteredRecords.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Icon(Icons.check_circle_outline, size: 64, color: Colors.grey.withValues(alpha: 0.3)),
             const SizedBox(height: 16),
             Text("No $emptyTitle records", style: const TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: filteredRecords.length,
      itemBuilder: (context, index) {
        return BeneficiaryCard(record: filteredRecords[index]);
      },
    );
  }
}
