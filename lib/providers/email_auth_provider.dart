import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../services/auth_service.dart';

enum EmailAuthStatus { idle, loading, success, error }

/// Holds the state for email/password sign up and login. Screens read this
/// via Provider rather than talking to Firebase directly.
class EmailAuthProvider extends ChangeNotifier {
  EmailAuthProvider({AuthService? authService}) : _authService = authService ?? AuthService();

  final AuthService _authService;

  EmailAuthStatus status = EmailAuthStatus.idle;
  String? email;
  String? errorMessage;
  int resendSecondsRemaining = 0;
  Timer? _resendTimer;

  static const int _resendCooldown = 30;

  Future<bool> signUp({required String name, required String email, required String password}) async {
    status = EmailAuthStatus.loading;
    errorMessage = null;
    notifyListeners();

    try {
      await _authService.signUpWithEmail(email: email, password: password, displayName: name);
      this.email = email;
      await _authService.sendEmailVerificationLink();
      _startResendCountdown();
      status = EmailAuthStatus.success;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      status = EmailAuthStatus.error;
      errorMessage = e.message ?? 'Could not create your account. Please try again.';
      notifyListeners();
      return false;
    } catch (_) {
      // Non-Firebase failure (e.g. Firebase not configured in this build).
      status = EmailAuthStatus.error;
      errorMessage = 'Sign up is unavailable right now. Please try again later.';
      notifyListeners();
      return false;
    }
  }

  Future<bool> logIn({required String email, required String password}) async {
    status = EmailAuthStatus.loading;
    errorMessage = null;
    notifyListeners();

    try {
      await _authService.signInWithEmail(email: email, password: password);
      status = EmailAuthStatus.success;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      status = EmailAuthStatus.error;
      errorMessage = e.message ?? 'Incorrect email or password.';
      notifyListeners();
      return false;
    } catch (_) {
      // Non-Firebase failure (e.g. Firebase not configured in this build).
      status = EmailAuthStatus.error;
      errorMessage = 'Login is unavailable right now. Please try again later.';
      notifyListeners();
      return false;
    }
  }

  /// Clears any error left over from a different screen sharing this
  /// provider (e.g. a failed login shouldn't show up on Sign Up).
  void clearError() {
    if (errorMessage == null) return;
    errorMessage = null;
    status = EmailAuthStatus.idle;
    notifyListeners();
  }

  void resendVerification() {
    if (resendSecondsRemaining > 0) return;
    _authService.sendEmailVerificationLink();
    _startResendCountdown();
  }

  void _startResendCountdown() {
    resendSecondsRemaining = _resendCooldown;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      resendSecondsRemaining--;
      if (resendSecondsRemaining <= 0) timer.cancel();
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    super.dispose();
  }
}
