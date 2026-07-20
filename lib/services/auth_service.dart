import 'package:firebase_auth/firebase_auth.dart';

/// Wraps Firebase Auth's phone-number verification flow. Screens never
/// call FirebaseAuth directly — they go through this service.
///
/// [FirebaseAuth.instance] is only touched inside the methods below, not at
/// construction time, so this can be safely instantiated (e.g. by a
/// Provider) before Firebase.initializeApp() has resolved.
class AuthService {
  AuthService({FirebaseAuth? firebaseAuth}) : _injectedFirebaseAuth = firebaseAuth;

  final FirebaseAuth? _injectedFirebaseAuth;
  FirebaseAuth get _firebaseAuth => _injectedFirebaseAuth ?? FirebaseAuth.instance;

  Future<void> sendOtp({
    required String phoneNumber,
    required void Function(String verificationId, int? resendToken) onCodeSent,
    required void Function(FirebaseAuthException error) onError,
    required void Function(UserCredential credential) onAutoVerified,
    int? forceResendingToken,
  }) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      forceResendingToken: forceResendingToken,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (credential) async {
        final userCredential = await _firebaseAuth.signInWithCredential(credential);
        onAutoVerified(userCredential);
      },
      verificationFailed: onError,
      codeSent: onCodeSent,
      codeAutoRetrievalTimeout: (verificationId) => onCodeSent(verificationId, null),
    );
  }

  Future<UserCredential> verifyOtp({
    required String verificationId,
    required String smsCode,
  }) {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    return _firebaseAuth.signInWithCredential(credential);
  }

  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await credential.user?.updateDisplayName(displayName);
    return credential;
  }

  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) {
    return _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  // TODO(backend): Figma specs a 6-digit email verification code, but Firebase
  // Auth's built-in email verification is link-based, not code-based. A
  // numeric-code flow needs a backend service (e.g. Cloud Function) to
  // generate/send/check the code — out of scope until that's stood up.
  Future<void> sendEmailVerificationLink() async {
    await _firebaseAuth.currentUser?.sendEmailVerification();
  }
}
