import 'package:chefs_shelf/Services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController {
  final AuthService _service = AuthService();

  Stream<User?> get authStateChanges => _service.authStateChanges;

  Future<void> signIn(String email, String password) =>
      _service.signIn(email, password);

  Future<void> register(String email, String password) =>
      _service.register(email, password);

  Future<void> signInWithGoogle() => _service.signInWithGoogle();

  Future<void> signOut() => _service.signOut();
}
