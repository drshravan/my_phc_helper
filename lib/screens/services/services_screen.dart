import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../../widgets/neumorphic_container.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Theme & Colors
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? AppColors.backgroundDark : AppColors.background;
    final baseTextColor = isDark ? AppColors.textWhite : AppColors.textDark;

    final services = [
      {'title': 'Telemedicine', 'icon': Icons.video_call, 'color': Colors.blue},
      {'title': 'Laboratory', 'icon': Icons.biotech, 'color': Colors.purple},
      {'title': 'Pharmacy', 'icon': Icons.local_pharmacy, 'color': Colors.green},
      {'title': 'Inventory', 'icon': Icons.inventory, 'color': Colors.orange},
      {'title': 'Ambulance', 'icon': Icons.airport_shuttle, 'color': Colors.red},
      {'title': 'Reports', 'icon': Icons.bar_chart, 'color': Colors.teal},
    ];

    return Scaffold(
      backgroundColor: baseColor,
      appBar: AppBar(
        title: Text("Services", style: TextStyle(fontWeight: FontWeight.bold, color: baseTextColor)),
        backgroundColor: baseColor,
        elevation: 0,
        iconTheme: IconThemeData(color: baseTextColor),
        centerTitle: true,
      ),
      body: SafeArea(
        child: GridView.builder(
          padding: const EdgeInsets.all(24),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 0.85,
          ),
          itemCount: services.length,
          itemBuilder: (context, index) {
            final service = services[index];
            return _buildServiceCard(
              context,
              service['title'] as String,
              service['icon'] as IconData,
              service['color'] as Color,
            );
          },
        ),
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, String title, IconData icon, Color color) {
    return NeumorphicContainer(
      onTap: () {
        // Placeholder action
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("$title feature coming soon!")),
        );
      },
      borderRadius: BorderRadius.circular(20),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          NeumorphicContainer(
            padding: const EdgeInsets.all(16),
            boxShape: BoxShape.circle,
            child: Icon(icon, size: 32, color: color),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
