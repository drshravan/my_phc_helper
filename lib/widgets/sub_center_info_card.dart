import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../widgets/neumorphic_container.dart';

class SubCenterInfoCard extends StatelessWidget {
  final String subCenterName;
  final int totalDeliveries;
  final int normalDeliveries;
  final int lscsDeliveries; // If needed to show specific breakup or just normal vs other
  final int abortions;
  final int govtDeliveries;
  final int privateDeliveries;
  final int pendingUpdates;
  final double dataCompletionPercent; // 0.0 to 100.0
  final VoidCallback onTap;

  const SubCenterInfoCard({
    super.key,
    required this.subCenterName,
    required this.totalDeliveries,
    required this.normalDeliveries,
    required this.lscsDeliveries,
    required this.abortions,
    required this.govtDeliveries,
    required this.privateDeliveries,
    required this.pendingUpdates,
    required this.dataCompletionPercent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Determine status color based on completion
    final completionColor = dataCompletionPercent > 90 
        ? AppColors.success 
        : (dataCompletionPercent > 50 ? AppColors.warning : AppColors.error);

    return NeumorphicContainer(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  subCenterName,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              CircularProgressIndicator(
                value: dataCompletionPercent / 100,
                backgroundColor: Colors.grey.withValues(alpha: 0.2),
                color: completionColor,
                strokeWidth: 4,
              ), // Could be replaced with a small text or badge
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "Data Completed: ${dataCompletionPercent.toStringAsFixed(1)}%",
            style: TextStyle(
              color: completionColor,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          const Divider(height: 24),
          
          // Stats Grid
          Row(
            children: [
              Expanded(child: _buildStatItem(context, "Deliveries", totalDeliveries.toString())),
              Expanded(child: _buildStatItem(context, "Pending", pendingUpdates.toString(), isHighlight: pendingUpdates > 0)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildStatItem(context, "Normal", normalDeliveries.toString())),
              Expanded(child: _buildStatItem(context, "Abortions", abortions.toString())),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildStatItem(context, "Govt", govtDeliveries.toString())),
              Expanded(child: _buildStatItem(context, "Private", privateDeliveries.toString())),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value, {bool isHighlight = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.7),
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: isHighlight ? AppColors.error : null,
          ),
        ),
      ],
    );
  }
}
