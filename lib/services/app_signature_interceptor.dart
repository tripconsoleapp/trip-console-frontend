import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';

/// Signs every outgoing request with HMAC-SHA256 so a bare HTTP client
/// (Postman, curl, a decompiled copy of the API base URL) can't call the
/// backend without also holding the shared secret. Backend recomputes the
/// same HMAC over method+path+timestamp+body and rejects on mismatch or a
/// timestamp older than 5 minutes.
///
/// The secret is passed via `--dart-define=APP_SIGNATURE_SECRET=xxx` for
/// now (keeps it out of source control) rather than a hardcoded literal
/// (trivially recoverable from the compiled APK). Migrate to Android
/// Keystore / iOS Keychain via `flutter_secure_storage` once there's a
/// bootstrap/attestation endpoint to fetch it from at runtime.
class AppSignatureInterceptor extends Interceptor {
  static const String _secret = String.fromEnvironment(
    'APP_SIGNATURE_SECRET',
    defaultValue: '',
  );

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (_secret.isEmpty) {
      // Fail loudly in dev rather than silently sending unsigned requests.
      assert(false, 'APP_SIGNATURE_SECRET not set — pass via --dart-define');
      return handler.next(options);
    }

    final timestamp = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();

    // CRITICAL: this must be the exact bytes that end up on the wire. If
    // options.data is signed as an object but Dio re-serializes it
    // differently when it actually sends (key ordering, number
    // formatting), the backend's hash won't match. Serialize once here,
    // sign that exact string, and send that exact string below.
    final body = options.data == null ? '' : jsonEncode(options.data);
    final method = options.method.toUpperCase();
    final path = options.path.startsWith('/') ? options.path : '/${options.path}';
    final signedContent = '$method:$path:$timestamp:$body';

    final hmac = Hmac(sha256, utf8.encode(_secret));
    final signature = hmac.convert(utf8.encode(signedContent)).toString();

    options.headers['x-app-signature'] = signature;
    options.headers['x-app-signature-timestamp'] = timestamp;

    if (options.data != null) {
      options.data = body;
      options.headers['Content-Type'] = 'application/json';
    }

    handler.next(options);
  }
}
