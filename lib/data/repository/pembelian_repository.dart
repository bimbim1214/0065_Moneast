import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:pamfix/data/model/request/admin/pembelian_request_model.dart';
import 'package:pamfix/data/model/response/pembelian_response_model.dart';
import 'package:pamfix/services/service_http_client.dart';

class PembelianRepository {
  final ServiceHttpClient httpClient;

  PembelianRepository(this.httpClient);

  Future<Either<String, List<PembelianResponseModel>>> getAllPembelian() async {
    try {
      final response = await httpClient.get('pembelianbuah');
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return Right(data.map((e) => PembelianResponseModel.fromMap(e)).toList());
      } else {
        final error = json.decode(response.body);
        return Left(error['message'] ?? 'Gagal mengambil data');
      }
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }

  Future<Either<String, PembelianResponseModel>> addPembelian(PembelianRequestModel request) async {
    try {
      final response = await httpClient.postWithToken('pembelianbuah', request.toMap());
      if (response.statusCode == 201) {
        return Right(PembelianResponseModel.fromJson(response.body));
      } else {
        final error = json.decode(response.body);
        return Left(error['message'] ?? 'Gagal menambahkan pembelian');
      }
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }

  Future<Either<String, PembelianResponseModel>> updatePembelian(int id, PembelianRequestModel request) async {
    try {
      final response = await httpClient.put('pembelianbuah/$id', request.toMap());
      if (response.statusCode == 200) {
        return Right(PembelianResponseModel.fromJson(response.body));
      } else {
        final error = json.decode(response.body);
        return Left(error['message'] ?? 'Gagal memperbarui data');
      }
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }

  Future<Either<String, bool>> deletePembelian(int id) async {
    try {
      final response = await httpClient.delete('pembelianbuah/$id');
      if (response.statusCode == 200) {
        return const Right(true);
      } else {
        final error = json.decode(response.body);
        return Left(error['message'] ?? 'Gagal menghapus data');
      }
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }
}
