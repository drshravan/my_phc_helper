import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_phc_helper/screens/mch/edd/edd_screen.dart';
import '../../utils/app_colors.dart';

class MchScreen extends StatelessWidget {
  const MchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("MCH")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildOptionCard(
              title: "Registration",
              subtitle: "Register new ANC",
              icon: Icons.app_registration,
              color: Colors.purple,
              onTap: () {},
            ),
            const SizedBox(height: 16),
            _buildOptionCard(
              title: "EDD List",
              subtitle: "Track EDDs & Deliveries",
              icon: Icons.calendar_today,
              color: AppColors.secondary,
              onTap: () => Get.to(() => const EddScreen()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(color: AppColors.textLight),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.textLight,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
