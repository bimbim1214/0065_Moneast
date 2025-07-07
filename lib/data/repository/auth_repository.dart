import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pamfix/data/model/request/auth/login_request_model.dart';
import 'package:pamfix/data/model/request/auth/register_request_model.dart';
import 'package:pamfix/data/model/response/auth_response_model.dart';
import 'package:pamfix/services/service_http_client.dart'; // Adjust the import according to your project structure

class AuthRepository {
  final ServiceHttpClient _serviceHttpClient;
  final secureStorage = FlutterSecureStorage();

  AuthRepository(this._serviceHttpClient);

  Future<Either<String, AuthResponseModel>> login(
  LoginRequestModel requestModel,
  ) async {
    print("🔍 Masuk ke AuthRepository.login()");
    try {
      final response = await _serviceHttpClient.post(
        "login",
        requestModel.toMap(),
      );

      print("📬 HTTP response diterima, status: ${response.statusCode}");
      final jsonResponse = json.decode(response.body);
      print("📥 JSON decoded: $jsonResponse");

      if (response.statusCode == 200) {
        final loginResponse = AuthResponseModel.fromMap(jsonResponse);
        print("✅ Token: ${loginResponse.data?.token}");
        return Right(loginResponse);
      } else {
        print("❌ Status bukan 200: ${jsonResponse['message']}");
        return Left(jsonResponse['message'] ?? "Login failed");
      }
    } catch (e) {
      print("❌ Exception dalam login: $e");
      return Left("Terjadi kesalahan saat login.");
    }
  }


  Future<Either<String, String>> register(
    RegisterRequestModel requestModel,
  ) async {
    try {
      final response = await _serviceHttpClient.post(
        "register",
        requestModel.toMap(),
      );
      final jsonResponse = json.decode(response.body);
      if (response.statusCode == 201) {
        final registerResponse = jsonResponse['message'] as String;
        log("Registration successful: ${registerResponse}");
        return Right(registerResponse);
      } else {
        log("Registration failed: ${jsonResponse['message']}");
        return Left(jsonResponse['message'] ?? "Registration failed");
      }
    } catch (e) {
      log("Error in registration: $e");
      return Left("An error occurred while registering.");
    }
  }
}
