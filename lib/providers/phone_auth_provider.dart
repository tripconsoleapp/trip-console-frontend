import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../services/auth_service.dart';

enum PhoneAuthStatus { idle, loading, codeSent, verified, error }

/// Holds the state for the phone-number + OTP login flow: the in-flight
/// request, the verification id Firebase hands back, the resend countdown,
/// and any error to show. Screens read this via Provider rather than
/// talking to Firebase directly.
class PhoneAuthProvider extends ChangeNotifier {
  PhoneAuthProvider({AuthService? authService}) : _authService = authService ?? AuthService();

  final AuthService _authService;
  Timer? _resendTimer;

  PhoneAuthStatus status = PhoneAuthStatus.idle;
  String? phoneNumber;
  String? _verificationId;
  int? _resendToken;
  String? errorMessage;
  int resendSecondsRemaining = 0;

  static const int _resendCooldown = 30;

  Future<void> sendOtp(String phoneNumber) async {
    this.phoneNumber = phoneNumber;
    status = PhoneAuthStatus.loading;
    errorMessage = null;
    notifyListeners();

    try {
      await _authService.sendOtp(
        phoneNumber: phoneNumber,
        forceResendingToken: _resendToken,
        onCodeSent: (verificationId, resendToken) {
          _verificationId = verificationId;
          _resendToken = resendToken;
          status = PhoneAuthStatus.codeSent;
          _startResendCountdown();
          notifyListeners();
        },
        onError: (error) {
          status = PhoneAuthStatus.error;
          errorMessage = error.message ?? 'Failed to send OTP. Please try again.';
          notifyListeners();
        },
        onAutoVerified: (_) {
          status = PhoneAuthStatus.verified;
          notifyListeners();
        },
      );
    } catch (e) {
      status = PhoneAuthStatus.error;
      errorMessage = 'Something went wrong. Please try again.';
      notifyListeners();
    }
  }

  Future<bool> verifyOtp(String smsCode) async {
    if (_verificationId == null) return false;
    status = PhoneAuthStatus.loading;
    errorMessage = null;
    notifyListeners();

    try {
      await _authService.verifyOtp(verificationId: _verificationId!, smsCode: smsCode);
      status = PhoneAuthStatus.verified;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      status = PhoneAuthStatus.error;
      errorMessage = e.message ?? 'Incorrect code. Please try again.';
      notifyListeners();
      return false;
    }
  }

  void resendOtp() {
    if (resendSecondsRemaining > 0 || phoneNumber == null) return;
    sendOtp(phoneNumber!);
  }

  void _startResendCountdown() {
    resendSecondsRemaining = _resendCooldown;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      resendSecondsRemaining--;
      if (resendSecondsRemaining <= 0) {
        timer.cancel();
      }
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    super.dispose();
  }
}
