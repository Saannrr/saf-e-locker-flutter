import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart'; // Untuk kDebugMode

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Stream untuk memantau perubahan status autentikasi pengguna
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Mendapatkan pengguna saat ini
  User? get currentUser => _firebaseAuth.currentUser;

  // Fungsi Login dengan Email dan Password
  Future<User?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print('Failed to sign in: ${e.message} (Code: ${e.code})');
      }
      // Anda bisa melempar custom exception atau mengembalikan null/pesan error
      rethrow; // Biarkan UI menangani error spesifik jika perlu
    }
  }

  // Fungsi Registrasi dengan Email dan Password (Contoh)
  Future<User?> signUpWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential result = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      // Di sini Anda bisa menambahkan logika untuk menyimpan data pengguna tambahan
      // ke Firestore/Realtime Database setelah registrasi, misalnya role.
      // await FirebaseFirestore.instance.collection('users').doc(result.user?.uid).set({
      //   'email': email,
      //   'role': 'user', // Default role
      //   'createdAt': FieldValue.serverTimestamp(),
      // });
      return result.user;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print('Failed to sign up: ${e.message} (Code: ${e.code})');
      }
      rethrow;
    }
  }

  // Fungsi Logout
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      if (kDebugMode) {
        print('Error signing out: $e');
      }
      // Tangani error jika perlu
    }
  }
}
