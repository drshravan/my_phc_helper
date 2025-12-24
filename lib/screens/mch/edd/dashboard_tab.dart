import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:my_phc_helper/data/repositories/anc_repository.dart';

class DashboardTab extends StatefulWidget {
  const DashboardTab({super.key});

  @override
  State<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
  final AncRepository _repo = Get.find<AncRepository>();

  int totalDelivered = 0;
  int normalDelivered = 0;
  int lscsDelivered = 0;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  void _loadStats() async {
    final total = await _repo.getDeliveredCount();
    final normal = await _repo.getNormalDeliveryCount();
    final lscs = await _repo.getLscsDeliveryCount();

    if (mounted) {
      setState(() {
        totalDelivered = total;
        normalDelivered = normal;
        lscsDelivered = lscs;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double lscsPercent = totalDelivered > 0
        ? lscsDelivered / totalDelivered
        : 0.0;
    double normalPercent = totalDelivered > 0
        ? normalDelivered / totalDelivered
        : 0.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (totalDelivered == 0)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "No delivery data available yet. Import Excel or add records to see stats.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          _buildStatsCard(
            "LSCS Rate",
            "$lscsDelivered out of $totalDelivered",
            lscsPercent,
            "${(lscsPercent * 100).toStringAsFixed(1)}%",
            Colors.orange,
          ),
          const SizedBox(height: 16),
          _buildStatsCard(
            "Normal Delivery Rate",
            "$normalDelivered out of $totalDelivered",
            normalPercent,
            "${(normalPercent * 100).toStringAsFixed(1)}%",
            Colors.green,
          ),
          const SizedBox(height: 16),
          // Placeholder for Govt/Private as we don't have exact logic/columns yet
          _buildStatsCard(
            "Govt vs Private",
            "Govt Inst.",
            0.0,
            "0%",
            Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(
    String title,
    String subtitle,
    double percent,
    String percentText,
    Color color,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(subtitle, style: const TextStyle(color: Colors.grey)),
              ],
            ),
            CircularPercentIndicator(
              radius: 40.0,
              lineWidth: 8.0,
              percent: percent > 1.0 ? 1.0 : percent,
              center: Text(
                percentText,
                style: TextStyle(fontWeight: FontWeight.bold, color: color),
              ),
              progressColor: color,
              backgroundColor: color.withValues(alpha: 0.1),
              circularStrokeCap: CircularStrokeCap.round,
              animation: true,
            ),
          ],
        ),
      ),
    );
  }
}
