import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/app_colors.dart';
import '../../widgets/neumorphic_container.dart';
import 'edd/edd_screen.dart';
import 'registration/registration_screen.dart';


class MchScreen extends StatelessWidget {
  const MchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("MCH"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Registration module deferred by user request
              // _buildNeomorphicOptionCard(
              //   context,
              //   title: "Registration",
              //   subtitle: "Register new ANC",
              //   icon: Icons.app_registration,
              //   accentColor: Colors.purple,
              //   onTap: () => Get.to(() => const RegistrationScreen()),
              // ),
              const SizedBox(height: 24),
              _buildNeomorphicOptionCard(
                context,
                title: "EDD List",
                subtitle: "Track EDDs & Deliveries",
                icon: Icons.calendar_today,
                accentColor: AppColors.secondary,
                onTap: () => Get.to(() => const EddScreen()),
              ),
              const SizedBox(height: 24),
              _buildNeomorphicOptionCard(
                context,
                title: "ANC Registration",
                subtitle: "for new ANC Registration",
                icon: Icons.paste,
                accentColor: Colors.blue,
                onTap: () => Get.to(() => const RegistrationScreen()),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNeomorphicOptionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    return NeumorphicContainer(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          NeumorphicContainer(
            padding: const EdgeInsets.all(12),
            boxShape: BoxShape.circle,
            child: Icon(icon, color: accentColor, size: 32),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                      ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Theme.of(context).iconTheme.color?.withValues(alpha: 0.5),
          ),
        ],
      ),
    );
  }
}
