import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/neumorphic_container.dart';
import '../mch/mch_screen.dart';

class ProgramsScreen extends StatelessWidget {
  const ProgramsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Programs"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            children: [
              _buildNeomorphicProgramCard(
                context,
                title: "MCH",
                icon: Icons.pregnant_woman,
                accentColor: Colors.pinkAccent,
                onTap: () => Get.to(() => const MchScreen()),
              ),
              _buildNeomorphicProgramCard(
                context,
                title: "Immunization",
                icon: Icons.vaccines,
                accentColor: Colors.blue,
              ),
              _buildNeomorphicProgramCard(
                context,
                title: "Communicable Disease",
                icon: Icons.coronavirus,
                accentColor: Colors.orange,
              ),
              _buildNeomorphicProgramCard(
                context,
                title: "NCD",
                icon: Icons.monitor_heart,
                accentColor: Colors.red,
              ),
              _buildNeomorphicProgramCard(
                context,
                title: "Leprosy LCDC",
                icon: Icons.medical_services,
                accentColor: Colors.purple,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNeomorphicProgramCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color accentColor,
    VoidCallback? onTap,
  }) {
    return NeumorphicContainer(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Inner circle for icon
          NeumorphicContainer(
            padding: const EdgeInsets.all(12),
            boxShape: BoxShape.circle,
            child: Icon(icon, size: 32, color: accentColor),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 14, // Slightly smaller to fit grid
                ),
          ),
        ],
      ),
    );
  }
}
