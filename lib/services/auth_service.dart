import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Stream<User?> get authStateChanges => _auth.authStateChanges();
  static User? get currentUser => _auth.currentUser;

  // Initialize default admin user
  static Future<void> initializeAdminUser() async {
    const adminEmail = 'padma@gmail.com';
    const adminPassword = 'padma@123';

    try {
      QuerySnapshot qs = await _firestore
          .collection('users')
          .where('email', isEqualTo: adminEmail)
          .get();

      if (qs.docs.isEmpty) {
        try {
          UserCredential uc = await _auth.createUserWithEmailAndPassword(
            email: adminEmail,
            password: adminPassword,
          );

          await _firestore.collection('users').doc(uc.user!.uid).set({
            'email': adminEmail,
            'role': 'admin',
            'name': 'Admin User',
            'isActive': true,
            'createdAt': FieldValue.serverTimestamp(),
          });

          await _auth.signOut();
        } catch (e) {
          try {
            UserCredential uc2 = await _auth.signInWithEmailAndPassword(
              email: adminEmail,
              password: adminPassword,
            );

            await _firestore.collection('users').doc(uc2.user!.uid).set({
              'email': adminEmail,
              'role': 'admin',
              'name': 'Admin User',
              'isActive': true,
              'createdAt': FieldValue.serverTimestamp(),
            });

            await _auth.signOut();
          } catch (e2) {
            debugPrint('Error creating admin profile: $e2');
          }
        }
      }
    } catch (e) {
      debugPrint('Error initializing admin: $e');
    }
  }

  // FIXED: Sign in without Pigeon calls
  static Future<User?> signIn(String email, String password) async {
    try {
      if (_auth.currentUser != null) await _auth.signOut();

      UserCredential uc = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // Get user directly from Firebase (NO PIGEON CALLS)
      User? user = uc.user;
      if (user == null) throw Exception('Login failed - no user returned');

      // Verify admin role using Firestore directly
      DocumentSnapshot ds = await _firestore.collection('users').doc(user.uid).get();
      
      if (ds.exists) {
        Map<String, dynamic> data = ds.data() as Map<String, dynamic>;
        if (data['role'] == 'admin' && data['isActive'] == true) {
          debugPrint('Login successful for admin: ${user.email}');
          return user; // Return Firebase user directly
        }
      }

      await _auth.signOut();
      throw Exception('Access denied. Admin privileges required.');
    } on FirebaseAuthException catch (e) {
      String msg = switch (e.code) {
        'user-not-found' => 'No user found for that email.',
        'wrong-password' => 'Wrong password provided.',
        'invalid-email' => 'Invalid email format.',
        'user-disabled' => 'User account disabled.',
        'too-many-requests' => 'Too many attempts, try later.',
        _ => e.message ?? 'Authentication error.'
      };
      throw Exception(msg);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Register new admin (NO PIGEON CALLS)
  static Future<User?> registerAdmin({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      UserCredential uc = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      await _firestore.collection('users').doc(uc.user!.uid).set({
        'email': email.trim(),
        'role': 'admin',
        'name': name.trim(),
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return uc.user;
    } on FirebaseAuthException catch (e) {
      String msg = switch (e.code) {
        'weak-password' => 'Password is too weak.',
        'email-already-in-use' => 'Email is already registered.',
        'invalid-email' => 'Invalid email format.',
        _ => e.message ?? 'Registration failed.'
      };
      throw Exception(msg);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Sign out
  static Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      debugPrint('Sign out error: $e');
    }
  }

  // Check if current user is admin (NO PIGEON CALLS)
  static Future<bool> isAdmin() async {
    User? user = _auth.currentUser;
    if (user == null) return false;

    try {
      DocumentSnapshot ds = await _firestore.collection('users').doc(user.uid).get();
      if (!ds.exists) return false;
      
      Map<String, dynamic> data = ds.data() as Map<String, dynamic>;
      return data['role'] == 'admin' && data['isActive'] == true;
    } catch (e) {
      return false;
    }
  }

  // Get current user profile (NO PIGEON CALLS)
  static Future<Map<String, dynamic>?> getCurrentUserProfile() async {
    User? user = _auth.currentUser;
    if (user == null) return null;

    try {
      DocumentSnapshot ds = await _firestore.collection('users').doc(user.uid).get();
      if (ds.exists) {
        return ds.data() as Map<String, dynamic>;
      }
    } catch (e) {
      debugPrint('Error getting user profile: $e');
    }
    return null;
  }
}
