<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp();
    // REMOVED: AuthService.initializeAdminUser() - this was causing the Pigeon error
    // REMOVED: FirestoreService.createSampleData() - this was causing permission errors
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
  }
  
  runApp(const FoodieAdminApp());
}

class FoodieAdminApp extends StatelessWidget {
  const FoodieAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Foodie Admin Panel',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF4A90E2),
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: GoogleFonts.poppins(
            color: const Color(0xFF2E3A47),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          iconTheme: const IconThemeData(color: Color(0xFF2E3A47)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4A90E2),
            foregroundColor: Colors.white,
            textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ),
      home: const LoginPage(),
    );
  }
}
=======
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services/auth_service.dart';
import 'services/firestore_service.dart';
import 'pages/login_page.dart';  // start here

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await AuthService.initializeAdminUser();
  await FirestoreService.createSampleData();
  runApp(const FoodieAdminApp());
}

class FoodieAdminApp extends StatelessWidget {
  const FoodieAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Foodie Admin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const LoginPage(),
    );
  }
}
>>>>>>> a330a6beaf92aaae151a5a3470617d41e51bbcdf
