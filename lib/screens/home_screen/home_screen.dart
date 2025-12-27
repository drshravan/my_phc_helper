import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_phc_helper/screens/programs/programs_screen.dart';
import '../../utils/app_colors.dart';
import '../../widgets/neumorphic_container.dart';
import 'package:my_phc_helper/screens/reports/sub_center_dashboard.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Determine the gradient based on theme for the header
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    // Header Row with Theme Toggle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(Icons.menu, size: 28), // Drawer Icon placeholder
                        NeumorphicContainer(
                          padding: const EdgeInsets.all(10),
                          boxShape: BoxShape.circle,
                          onTap: () {
                            if (Get.isDarkMode) {
                              Get.changeThemeMode(ThemeMode.light);
                            } else {
                              Get.changeThemeMode(ThemeMode.dark);
                            }
                          },
                          child: Icon(
                            isDark ? Icons.light_mode : Icons.dark_mode,
                            size: 24,
                            color: Theme.of(context).iconTheme.color,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Main Title Card (Glass/Gradient)
                    NeumorphicContainer(
                      padding: EdgeInsets.zero,
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.local_hospital,
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "PHC Malkapur",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Primary Health Center",
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.8),
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverGrid.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                children: [
                  _buildNeumorphicServiceCard(
                    context,
                    "Programs",
                    Icons.dashboard,
                    AppColors.secondary,
                    () => Get.to(() => const ProgramsScreen()),
                  ),
                  _buildNeumorphicServiceCard(
                    context,
                    "Services",
                    Icons.medical_services,
                    Colors.blue,
                    () {},
                  ),
                  _buildNeumorphicServiceCard(
                    context,
                    "PHC Info",
                    Icons.info,
                    Colors.orange,
                    () {},
                  ),
                  _buildNeumorphicServiceCard(
                    context,
                    "Reports",
                    Icons.receipt_long,
                    Colors.purple,
                    () => Get.to(() => const SubCenterDashboard()),
                  ),
                ],
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }

  Widget _buildNeumorphicServiceCard(
    BuildContext context,
    String title,
    IconData icon,
    Color accentColor,
    VoidCallback onTap,
  ) {
    return NeumorphicContainer(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          NeumorphicContainer(
            padding: const EdgeInsets.all(12),
            boxShape: BoxShape.circle,
            // Small internal neumorphic button for the icon
            child: Icon(icon, color: accentColor, size: 32),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
          ),
        ],
      ),
    );
  }
}
