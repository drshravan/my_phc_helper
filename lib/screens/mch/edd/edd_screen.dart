import 'package:flutter/material.dart';
import 'package:my_phc_helper/utils/app_colors.dart';
import 'dashboard_tab.dart';
import 'edds_tab.dart';
import 'entries_tab.dart';

class EddScreen extends StatefulWidget {
  const EddScreen({super.key});

  @override
  State<EddScreen> createState() => _EddScreenState();
}

class _EddScreenState extends State<EddScreen> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    const DashboardTab(),
    const EddsTab(),
    const EntriesTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("EDD & Deliveries")),
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textLight,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "EDDs"),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_note),
            label: "Entries",
          ),
        ],
      ),
    );
  }
}
