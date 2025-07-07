import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ServiceHttpClient {
  final String baseUrl = 'http://192.168.22.188:8000/api/';
  final secureStorage = FlutterSecureStorage();

  //post
  Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse("$baseUrl$endpoint");
    print("📡 Mengirim POST ke: $url");
    print("📦 Body: ${jsonEncode(body)}");
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-type': 'application/json',
        },
        body: jsonEncode(body),
      );
      return response;
    } catch (e) {
      throw Exception("Post request failed: $e");
    }
  }

  //post with token
  Future<http.Response> postWithToken(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final token = await secureStorage.read(key: 'authToken');
    final url = Uri.parse('$baseUrl$endpoint');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(body),
      );
      return response;
    } catch (e) {
      throw Exception('Post request failed: $e');
    }
  }

  //get
  Future<http.Response> get(String endpoint) async {
    final token = await secureStorage.read(key: 'authToken');
    final url = Uri.parse('$baseUrl$endpoint');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      return response;
    } catch (e) {
      throw Exception('Get request failed: $e');
    }
  }
}
