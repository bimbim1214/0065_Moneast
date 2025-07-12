import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:pamfix/data/model/request/admin/kategori_request_model.dart';
import 'package:pamfix/data/model/response/kategori_response_model.dart';
import 'package:pamfix/services/service_http_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class KategoriRepository {
  final ServiceHttpClient _serviceHttpClient;
  final secureStorage = FlutterSecureStorage();

  KategoriRepository(this._serviceHttpClient);

  // ✅ Ambil semua kategori
  Future<Either<String, List<KategoriResponseModel>>> getAllKategori() async {
    try {
      final response = await _serviceHttpClient.get("kategori-buah");

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        final result = jsonList
            .map((e) => KategoriResponseModel.fromMap(e))
            .toList();
        return Right(result);
      } else {
        final error = json.decode(response.body);
        return Left(error['message'] ?? 'Gagal mengambil data kategori');
      }
    } catch (e) {
      return Left("Terjadi kesalahan: $e");
    }
  }

  // ✅ Tambah kategori
  Future<Either<String, KategoriResponseModel>> addKategori(
    KategoriRequestModel model,
  ) async {
    try {
      final response = await _serviceHttpClient.postWithToken(
        "kategori-buah",
        model.toMap(),
      );

      if (response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        return Right(KategoriResponseModel.fromMap(jsonData));
      } else {
        final error = json.decode(response.body);
        return Left(error['message'] ?? 'Gagal menambahkan kategori');
      }
    } catch (e) {
      return Left("Terjadi kesalahan: $e");
    }
  }

  // ✅ Ambil satu kategori
  Future<Either<String, KategoriResponseModel>> getKategoriById(int id) async {
    try {
      final response = await _serviceHttpClient.get("kategori-buah/$id");

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return Right(KategoriResponseModel.fromMap(jsonData));
      } else {
        final error = json.decode(response.body);
        return Left(error['message'] ?? 'Kategori tidak ditemukan');
      }
    } catch (e) {
      return Left("Terjadi kesalahan: $e");
    }
  }

  // ✅ Update kategori
  Future<Either<String, KategoriResponseModel>> updateKategori(
    int id,
    KategoriRequestModel model,
  ) async {
    try {
      final response = await _serviceHttpClient.put(
        "kategori-buah/$id",
        model.toMap(),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return Right(KategoriResponseModel.fromMap(jsonData));
      } else {
        final error = json.decode(response.body);
        return Left(error['message'] ?? 'Gagal update kategori');
      }
    } catch (e) {
      return Left("Terjadi kesalahan: $e");
    }
  }

  // ✅ Hapus kategori
  Future<Either<String, String>> deleteKategori(int id) async {
    try {
      final response = await _serviceHttpClient.delete("kategori-buah/$id");

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return Right(jsonData['message'] ?? 'Kategori berhasil dihapus');
      } else {
        final error = json.decode(response.body);
        return Left(error['message'] ?? 'Gagal menghapus kategori');
      }
    } catch (e) {
      return Left("Terjadi kesalahan: $e");
    }
  }
}
