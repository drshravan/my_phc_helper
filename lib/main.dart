import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_phc_helper/screens/home_screen/home_screen.dart';
import 'package:my_phc_helper/utils/app_theme.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_phc_helper/firebase_options.dart';
import 'package:my_phc_helper/data/repositories/firestore_repository.dart';
import 'package:my_phc_helper/data/repositories/mch_repository.dart';
// import 'data/repositories/anc_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    // Auth (Anonymous) to bypass basic security rules
    try {
      await FirebaseAuth.instance.signInAnonymously();
      print("Signed in anonymously: ${FirebaseAuth.instance.currentUser?.uid}");
    } catch (e) {
      print("Auth Failed: $e");
      // Continue anyway, rules might be public
    }

    // Dependency Injection
    Get.put(FirestoreRepository());
    Get.put(MchRepository());


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
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
