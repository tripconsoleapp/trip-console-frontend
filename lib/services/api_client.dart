import 'package:dio/dio.dart';

import 'app_signature_interceptor.dart';

/// Shared Dio client for the (not-yet-connected) backend API. Every screen
/// that needs a real network call once the backend is live should go
/// through `ApiClient.instance` rather than constructing its own `Dio()`,
/// so request signing stays applied everywhere.
///
/// Base URL is unset for now — set via `--dart-define=API_BASE_URL=...`
/// once the backend has a real address to point at.
class ApiClient {
  ApiClient._();

  static final Dio instance = Dio(
    BaseOptions(baseUrl: const String.fromEnvironment('API_BASE_URL')),
  )..interceptors.add(AppSignatureInterceptor());

  // TODO(backend): add an auth-token interceptor here once the backend
  // issues session tokens — attach after AppSignatureInterceptor so both
  // headers are present on every request.
}
