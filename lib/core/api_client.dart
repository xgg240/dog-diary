// ============================================================
//  API 客户端 (后端 118.195.186.228 nginx 反代 → 8000)
// ------------------------------------------------------------
//  - 单一 baseUrl, 走明文 HTTP (Day 2 决策: IP 直连不弹警告, 客户端不展示 URL)
//  - 5s 超时, 失败重试 1 次
//  - JSON 解析 + 错误包装
// ============================================================

import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart' show debugPrint, kDebugMode;
import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final int statusCode;
  final String message;
  final String? endpoint;
  ApiException(this.statusCode, this.message, {this.endpoint});
  @override
  String toString() => 'ApiException($statusCode): $message${endpoint != null ? " @ $endpoint" : ""}';
}

class ApiClient {
  // 后端 baseUrl (走 nginx 80 端口反代, 明文 HTTP)
  // 编译时可用 --dart-define=API_BASE=... 覆盖
  static const String baseUrl = String.fromEnvironment(
    'API_BASE',
    defaultValue: 'http://118.195.186.228',
  );

  /// GET /path?params - JSON 解码, 失败抛 ApiException
  static Future<dynamic> getJson(String path, {Map<String, String>? query, Duration? timeout}) async {
    final uri = Uri.parse('$baseUrl$path').replace(queryParameters: query);
    return _withRetry(() async {
      final resp = await http.get(uri, headers: const {
        'Accept': 'application/json',
        'User-Agent': 'dog_diary/1.0',
      }).timeout(timeout ?? const Duration(seconds: 5));
      return _parse(resp, path);
    }, path);
  }

  /// POST /path body=Map - JSON 解码
  static Future<dynamic> postJson(String path, {Map<String, dynamic>? body, Duration? timeout}) async {
    final uri = Uri.parse('$baseUrl$path');
    return _withRetry(() async {
      final resp = await http.post(uri, headers: const {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'User-Agent': 'dog_diary/1.0',
      }, body: jsonEncode(body ?? const {})).timeout(timeout ?? const Duration(seconds: 5));
      return _parse(resp, path);
    }, path);
  }

  static dynamic _parse(http.Response resp, String path) {
    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      // 解析 FastAPI 的 detail 字段, 转换为人类可读错误
      String message;
      try {
        final j = jsonDecode(utf8.decode(resp.bodyBytes));
        if (j is Map && j.containsKey('detail')) {
          final d = j['detail'];
          if (d is String) {
            message = d;
          } else if (d is List && d.isNotEmpty) {
            // FastAPI 422: [{loc, msg, ...}]
            message = (d as List).map((e) {
              if (e is Map && e.containsKey('msg')) {
                return '${(e['loc'] as List?)?.last ?? ''}: ${e['msg']}';
              }
              return e.toString();
            }).join('; ');
          } else {
            message = d.toString();
          }
        } else {
          message = resp.body.substring(0, resp.body.length.clamp(0, 200));
        }
      } on Exception {
        message = resp.body.substring(0, resp.body.length.clamp(0, 200));
      }
      throw ApiException(resp.statusCode, message, endpoint: path);
    }
    if (resp.body.isEmpty) return null;
    return jsonDecode(utf8.decode(resp.bodyBytes));
  }

  /// 简单重试: 失败 1 次 (5xx / TimeoutException / SocketException)
  /// 4xx (限流/参数错) 不重试, 避免浪费
  static Future<dynamic> _withRetry(Future<dynamic> Function() fn, String path) async {
    try {
      return await fn();
    } on TimeoutException {
      if (kDebugMode) debugPrint('[ApiClient] timeout retry: $path');
      return await fn();
    } on ApiException catch (e) {
      if (e.statusCode >= 500 && e.statusCode < 600) {
        if (kDebugMode) debugPrint('[ApiClient] 5xx retry: $path (${e.statusCode})');
        return await fn();
      }
      rethrow;
    } on Exception catch (e) {
      // SocketException / HandshakeException / ClientException 等网络错误 → 重试 1 次
      if (kDebugMode) debugPrint('[ApiClient] network error: $e, retry: $path');
      return await fn();
    }
  }
}
