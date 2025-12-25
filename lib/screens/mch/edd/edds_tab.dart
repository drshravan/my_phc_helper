import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_phc_helper/data/repositories/anc_repository.dart';
import 'month_details_screen.dart';
import 'month_stat_tile.dart';

class EddsTab extends StatefulWidget {
  const EddsTab({super.key});

  @override
  State<EddsTab> createState() => _EddsTabState();
}

class _EddsTabState extends State<EddsTab> {
  final AncRepository _repo = Get.find<AncRepository>();
  
  List<MonthStats> _monthStats = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() async {
    setState(() => _isLoading = true);
    final stats = await _repo.getAggregatedMonths();
    setState(() {
      _monthStats = stats;
      _isLoading = false;
    });
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
            );
          },
        ),
      ),
    );
  }
}
