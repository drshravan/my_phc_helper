import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_phc_helper/data/models/stats_models.dart';
import 'package:my_phc_helper/utils/app_colors.dart';

class MonthStatTile extends StatelessWidget {
  final MonthStats stats;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const MonthStatTile({
    super.key,
    required this.stats,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final date = DateTime(stats.year, stats.month);
    final monthName = DateFormat('MMMM yyyy').format(date);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Neumorphic Colors
    final baseColor = isDark ? AppColors.backgroundDark : AppColors.background;
    final lightShadow = isDark ? AppColors.shadowDarkTop : AppColors.shadowLightTop;
    final darkShadow = isDark ? AppColors.shadowDarkBottom : AppColors.shadowLightBottom;
    final textColor = isDark ? AppColors.textWhite : AppColors.textDark;

    // Visibility Colors
    final Color primaryColor = isDark ? AppColors.primaryLight : AppColors.primary;

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: lightShadow, offset: const Offset(-4, -4), blurRadius: 10),
            BoxShadow(color: darkShadow.withValues(alpha: 0.5), offset: const Offset(4, 4), blurRadius: 10),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  monthName,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: baseColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                       BoxShadow(color: lightShadow, offset: const Offset(-2, -2), blurRadius: 4),
                       BoxShadow(color: darkShadow.withValues(alpha: 0.2), offset: const Offset(2, 2), blurRadius: 4),
                    ],
                  ),
                  child: Text(
                    "${stats.total} EDDs",
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem("Normal", stats.normal, const Color(0xFF00BFA5)),
                _buildStatItem("LSCS", stats.lscs, const Color(0xFFFF9100)),
                _buildStatItem("Abortions", stats.abortion, const Color(0xFFFF5252)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem("Govt", stats.govt, const Color(0xFF448AFF)),
                _buildStatItem("Private", stats.private, const Color(0xFFE040FB)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, int count, Color color) {
    bool isZero = count == 0;
    return Column(
      children: [
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 20, // Larger for better visibility
            fontWeight: FontWeight.bold,
            color: isZero ? color.withValues(alpha: 0.3) : color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isZero ? color.withValues(alpha: 0.5) : color,
          ),
        ),
      ],
    );
  }
}
