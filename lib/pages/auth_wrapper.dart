import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth_service.dart';
import 'login_page.dart';
import 'home_page.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasData) {
          // Verify role
          return FutureBuilder<bool>(
            future: AuthService.isAdmin(),
            builder: (context, adminSnap) {
              if (adminSnap.connectionState == ConnectionState.waiting) {
                return const Scaffold(body: Center(child: CircularProgressIndicator()));
              }
              return adminSnap.data == true
                  ? const HomePage()
                  : const LoginPage();
            },
          );
        }
        return const LoginPage();
      },
    );
  }
}
