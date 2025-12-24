import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_phc_helper/screens/home_screen/home_screen.dart';
import 'package:my_phc_helper/utils/app_theme.dart';
import 'data/database/database.dart';
import 'data/repositories/anc_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Dependency Injection
    final db = AppDatabase();
    Get.put(db);
    Get.put(AncRepository(db));

    runApp(const MyApp());
  } catch (e, stack) {
    print("Startup Error: $e\n$stack");
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text(
              "Startup Error: $e",
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "My PHC Helper",
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
