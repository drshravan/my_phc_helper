import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_phc_helper/screens/mch/mch_screen.dart';

class ProgramsScreen extends StatelessWidget {
  const ProgramsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Programs")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildProgramCard(
              title: "MCH",
              icon: Icons.pregnant_woman,
              color: Colors.pinkAccent,
              onTap: () => Get.to(() => const MchScreen()),
            ),
            _buildProgramCard(
              title: "Immunization",
              icon: Icons.vaccines,
              color: Colors.blue,
            ),
            _buildProgramCard(
              title: "Communicable Disease",
              icon: Icons.coronavirus,
              color: Colors.orange,
            ),
            _buildProgramCard(
              title: "NCD",
              icon: Icons.monitor_heart,
              color: Colors.red,
            ),
            _buildProgramCard(
              title: "Leprosy LCDC",
              icon: Icons.medical_services,
              color: Colors.purple,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgramCard({
    required String title,
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [color.withValues(alpha: 0.7), color],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Colors.white),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
