import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;
  static final _firestore = FirebaseFirestore.instance;

  static Future<void> initializeAdminUser() async {
    const adminEmail = 'admin@example.com';
    const adminPassword = 'admin123';
    try {
      final snapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: adminEmail)
          .get();
      if (snapshot.docs.isEmpty) {
        final cred = await _auth.createUserWithEmailAndPassword(
          email: adminEmail,
          password: adminPassword,
        );
        await _firestore.collection('users').doc(cred.user!.uid).set({
          'email': adminEmail,
          'role': 'admin',
          'name': 'Default Admin',
          'isActive': true,
          'createdAt': FieldValue.serverTimestamp(),
        });
        await _auth.signOut();
        debugPrint('Default admin created');
      }
    } catch (e) {
      debugPrint('Admin init error: $e');
    }
  }

  static Future<User> signIn(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
    final doc = await _firestore.collection('users').doc(cred.user!.uid).get();
    final data = doc.data();
    if (data?['role'] == 'admin' && data?['isActive'] == true) {
      return cred.user!;
    }
    await _auth.signOut();
    throw Exception('Access denied: Admin only');
  }

  static Future<User> registerAdmin({
    required String name,
    required String email,
    required String password,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
    await _firestore.collection('users').doc(cred.user!.uid).set({
      'name': name.trim(),
      'email': email.trim(),
      'role': 'admin',
      'isActive': true,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return cred.user!;
  }

  static Future<void> signOut() async {
    await _auth.signOut();
  }
}
