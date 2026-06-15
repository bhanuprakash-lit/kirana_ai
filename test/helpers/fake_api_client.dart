import 'package:kirana_ai/core/services/api_client.dart';

/// Test double for [ApiClient]. Each method returns a value from a queue
/// (or a default) and records the URL it was called with so tests can assert
/// the app talked to the expected endpoint.
///
/// Provider tests override `apiClientProvider` with an instance of this class:
///
/// ```dart
/// final fake = FakeApiClient();
/// fake.queueGet('/kirana/finance/overview', {...});
/// final container = ProviderContainer(overrides: [
///   apiClientProvider.overrideWithValue(fake),
/// ]);
/// ```
class FakeApiClient implements ApiClient {
  /// Path -> queued response. Used for both successful and failure cases.
  final Map<String, List<Object?>> _responses = {};

  /// Every call made, in order. Each entry is `"METHOD <path>"`.
  final List<String> calls = [];

  /// Every body sent on POST/PATCH calls, in the order they were made.
  final List<Object?> postedBodies = [];

  // ── Queueing helpers ───────────────────────────────────────────────────────

  /// Enqueue a value to return for the next call to a path. Pass an
  /// [Exception] subclass (or `() => throw …`) to simulate a failure.
  void enqueue(String path, Object? value) {
    _responses.putIfAbsent(path, () => []).add(value);
  }

  Object? _dequeue(String path) {
    final queue = _responses[path];
    if (queue == null || queue.isEmpty) {
      throw StateError(
        'FakeApiClient: no response queued for "$path". '
        'Tests must call enqueue() for every path the code under test will hit.',
      );
    }
    final value = queue.removeAt(0);
    if (value is Exception) throw value;
    return value;
  }

  // ── ApiClient surface ──────────────────────────────────────────────────────

  @override
  Future<dynamic> get(String path) async {
    calls.add('GET $path');
    return _dequeue(path);
  }

  @override
  Future<dynamic> post(String path, dynamic body) async {
    calls.add('POST $path');
    postedBodies.add(body);
    return _dequeue(path);
  }

  @override
  Future<dynamic> patch(String path, dynamic body) async {
    calls.add('PATCH $path');
    postedBodies.add(body);
    return _dequeue(path);
  }

  @override
  Future<dynamic> delete(String path) async {
    calls.add('DELETE $path');
    return _dequeue(path);
  }

  @override
  Future<dynamic> postMultipart(
    String path, {
    required List<String> filePaths,
    String fileField = 'files',
    Map<String, String>? fields,
  }) async {
    calls.add('MULTIPART $path');
    return _dequeue(path);
  }

  // ── POS surface ────────────────────────────────────────────────────────────

  @override
  Future<Map<String, dynamic>?> posGet(String path) async {
    calls.add('POS GET $path');
    return _dequeue(path) as Map<String, dynamic>?;
  }

  @override
  Future<List<dynamic>?> posGetList(String path) async {
    calls.add('POS GET $path');
    return _dequeue(path) as List<dynamic>?;
  }

  @override
  Future<Map<String, dynamic>?> posPost(
    String path,
    Map<String, dynamic> body,
  ) async {
    calls.add('POS POST $path');
    postedBodies.add(body);
    return _dequeue(path) as Map<String, dynamic>?;
  }

  // ── OLTP surface ───────────────────────────────────────────────────────────

  @override
  Future<Map<String, dynamic>> getOltp(
    String table, {
    Map<String, String>? filters,
  }) async {
    calls.add('OLTP GET $table');
    return _dequeue(table) as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> postOltp(
    String table,
    Map<String, dynamic> body,
  ) async {
    calls.add('OLTP POST $table');
    postedBodies.add(body);
    return _dequeue(table) as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> patchOltp(
    String table,
    Map<String, dynamic> body, {
    Map<String, String>? filters,
  }) async {
    calls.add('OLTP PATCH $table');
    postedBodies.add(body);
    return _dequeue(table) as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> deleteOltp(
    String table, {
    required Map<String, String> filters,
  }) async {
    calls.add('OLTP DELETE $table');
    return _dequeue(table) as Map<String, dynamic>;
  }

  @override
  Future<dynamic> put(String path, body) {
    throw UnimplementedError();
  }

  @override
  Future<List<int>> getBytes(String path) async {
    calls.add('GET BYTES $path');
    return _dequeue(path) as List<int>;
  }
}
