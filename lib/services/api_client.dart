import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiException implements Exception {
  ApiException(this.message, {this.statusCode});
  final String message;
  final int? statusCode;
  @override
  String toString() => message;
}

class ApiClient {
  // Change only if the production API is deployed at a different path.
  static const String baseUrl = 'https://vindora.whf.bz/backend/mobile_api.php';
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<Map<String, dynamic>> get(String action) async => _send('GET', action);

  Future<Map<String, dynamic>> post(
    String action,
    Map<String, dynamic> body,
  ) async => _send('POST', action, body: body);

  Future<Map<String, dynamic>> _send(
    String method,
    String action, {
    Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse(baseUrl).replace(queryParameters: {'action': action});
    final token = await _storage.read(key: 'vindora_access_token');
    final headers = <String, String>{'Accept': 'application/json'};
    if (body != null) headers['Content-Type'] = 'application/json; charset=utf-8';
    if (token != null && token.isNotEmpty) headers['Authorization'] = 'Bearer $token';

    late http.Response response;
    try {
      if (method == 'GET') {
        response = await http.get(uri, headers: headers).timeout(const Duration(seconds: 20));
      } else {
        response = await http.post(uri, headers: headers, body: jsonEncode(body)).timeout(const Duration(seconds: 20));
      }
    } catch (_) {
      throw ApiException('تعذر الاتصال بالخادم. حاول مرة أخرى.');
    }

    Map<String, dynamic> data;
    try {
      final decoded = jsonDecode(response.body);
      data = decoded is Map<String, dynamic> ? decoded : <String, dynamic>{};
    } catch (_) {
      throw ApiException('استجابة الخادم غير مفهومة.', statusCode: response.statusCode);
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        (data['error'] ?? 'حدث خطأ أثناء تنفيذ الطلب.').toString(),
        statusCode: response.statusCode,
      );
    }
    return data;
  }

  Future<void> saveToken(String token) =>
      _storage.write(key: 'vindora_access_token', value: token);

  Future<void> clearToken() => _storage.delete(key: 'vindora_access_token');
}
