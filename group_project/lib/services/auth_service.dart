import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User> signInWithEmail(String email, String password) async {
    debugPrint('[AuthService] signInWithEmail called, email=$email');
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      debugPrint('[AuthService] Sign in success, uid=${result.user?.uid}');
      return result.user!;
    } on FirebaseAuthException catch (e) {
      debugPrint('[AuthService] FirebaseAuthException: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('[AuthService] Unknown error: $e');
      throw Exception('unknown-error');
    }
  }

  Future<User> signUpWithEmail(String email, String password) async {
    debugPrint('[AuthService] signUpWithEmail called, email=$email');
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      debugPrint('[AuthService] Sign up success, uid=${result.user?.uid}');
      return result.user!;
    } on FirebaseAuthException catch (e) {
      debugPrint('[AuthService] FirebaseAuthException: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('[AuthService] Unknown error: $e');
      throw Exception('unknown-error');
    }
  }

  Future<void> signOut() async {
    debugPrint('[AuthService] Signing out...');
    await _auth.signOut();
    debugPrint('[AuthService] Sign out complete.');
  }

  User? get currentUser => _auth.currentUser;
}
