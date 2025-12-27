import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/repositories/mch_repository.dart';
import '../../widgets/sub_center_info_card.dart';
import '../../data/models/stats_models.dart';
import 'sub_center_beneficiary_list.dart';

class SubCenterDashboard extends StatefulWidget {
  const SubCenterDashboard({super.key});

  @override
  State<SubCenterDashboard> createState() => _SubCenterDashboardState();
}

class _SubCenterDashboardState extends State<SubCenterDashboard> {
  late Future<List<SubCenterStats>> _statsFuture;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  void _loadStats() {
    // Reload logic for Pull-to-Refresh
    final repo = Get.find<MchRepository>();
    setState(() {
      _statsFuture = repo.getSubCenterStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Sub Center Monitoring"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder<List<SubCenterStats>>(
        future: _statsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          
          final stats = snapshot.data ?? [];
          if (stats.isEmpty) {
            return const Center(child: Text("No data available"));
          }

          return RefreshIndicator(
            onRefresh: () async => _loadStats(),
            child: ListView.builder( // Use ListView for cards usually, or Grid
              padding: const EdgeInsets.all(16),
              itemCount: stats.length,
              itemBuilder: (context, index) {
                final item = stats[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: SubCenterInfoCard(
                    subCenterName: item.subCenterName,
                    totalDeliveries: item.totalDeliveries,
                    normalDeliveries: item.normal,
                    lscsDeliveries: item.lscs,
                    abortions: item.abortion,
                    govtDeliveries: item.govt,
                    privateDeliveries: item.private,
                    pendingUpdates: item.pendingDeliveryUpdates,
                    dataCompletionPercent: item.dataCompletionPercentage,
                    onTap: () {
                       Get.to(() => SubCenterBeneficiaryList(subCenterName: item.subCenterName));
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
