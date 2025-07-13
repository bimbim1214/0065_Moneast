import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:pamfix/data/model/request/admin/buah_request_model.dart';
import 'package:pamfix/data/model/response/buah_response_model.dart';
import 'package:pamfix/services/service_http_client.dart';

class BuahRepository {
   final ServiceHttpClient _serviceHttpClient;
  final secureStorage = FlutterSecureStorage();

  BuahRepository(this._serviceHttpClient);

  /// GET: Ambil semua buah
  Future<Either<String, List<BuahResponsesModel>>> getAllBuah() async {
    try {
      final response = await _serviceHttpClient.get("buah");

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        final listBuah =
            jsonResponse.map((e) => BuahResponsesModel.fromMap(e)).toList();
        return Right(listBuah);
      } else {
        final error = json.decode(response.body);
        return Left(error['message'] ?? 'Gagal mengambil data buah');
      }
    } catch (e) {
      return Left("Terjadi kesalahan saat mengambil data buah: $e");
    }
  }

  /// POST: Tambah buah baru
  Future<Either<String, BuahResponsesModel>> addBuah(
    BuahRequestModel requestModel,
  ) async {
    try {
      final response = await _serviceHttpClient.postWithToken(
        "buah",
        requestModel.toMap(),
      );

      if (response.statusCode == 201) {
        final jsonResponse = json.decode(response.body);
        final buah = BuahResponsesModel.fromMap(jsonResponse);
        return Right(buah);
      } else {
        final error = json.decode(response.body);
        return Left(error['message'] ?? 'Gagal menambahkan buah');
      }
    } catch (e) {
      return Left("Terjadi kesalahan saat menambahkan buah: $e");
    }
  }

  /// GET: Detail buah tertentu
  Future<Either<String, BuahResponsesModel>> getBuahById(int id) async {
    try {
      final response = await _serviceHttpClient.get("buah/$id");

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return Right(BuahResponsesModel.fromMap(jsonResponse));
      } else {
        final error = json.decode(response.body);
        return Left(error['message'] ?? 'Buah tidak ditemukan');
      }
    } catch (e) {
      return Left("Terjadi kesalahan saat mengambil detail buah: $e");
    }
  }

  /// PUT: Update buah
  Future<Either<String, BuahResponsesModel>> updateBuah(
    int id,
    BuahRequestModel requestModel,
  ) async {
    try {
      final response = await _serviceHttpClient.put(
        "buah/$id",
        requestModel.toMap(),
      );


      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return Right(BuahResponsesModel.fromMap(jsonResponse));
      } else {
        final error = json.decode(response.body);
        return Left(error['message'] ?? 'Gagal update buah');
      }
    } catch (e) {
      return Left("Terjadi kesalahan saat update buah: $e");
    }
  }

  /// DELETE: Hapus buah
  Future<Either<String, String>> deleteBuah(int id) async {
    try {
      final response = await _serviceHttpClient.delete("buah/$id");

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return Right(jsonResponse['message'] ?? 'Buah berhasil dihapus');
      } else {
        final error = json.decode(response.body);
        return Left(error['message'] ?? 'Gagal menghapus buah');
      }
    } catch (e) {
      return Left("Terjadi kesalahan saat menghapus buah: $e");
    }
  }
}
