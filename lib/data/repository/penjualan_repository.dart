import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:pamfix/data/model/request/admin/penjualan_request_model.dart';
import 'package:pamfix/data/model/response/penjualan_response_model.dart';
import 'package:pamfix/services/service_http_client.dart';

class PenjualanRepository {
  final ServiceHttpClient httpClient;

  PenjualanRepository(this.httpClient);

  Future<Either<String, List<PenjualanResponseModel>>> getAllPenjualan() async {
    try {
      final response = await httpClient.get('penjualanbuah');
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return Right(data.map((e) => PenjualanResponseModel.fromMap(e)).toList());
      } else {
        final error = json.decode(response.body);
        return Left(error['message'] ?? 'Gagal mengambil data');
      }
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }

  Future<Either<String, PenjualanResponseModel>> addPenjualan(PenjualanRequestModel request) async {
    try {
      final response = await httpClient.postWithToken('penjualanbuah', request.toMap());
      if (response.statusCode == 201) {
        return Right(PenjualanResponseModel.fromJson(response.body));
      } else {
        final error = json.decode(response.body);
        return Left(error['message'] ?? 'Gagal menambahkan penjualan');
      }
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }

  Future<Either<String, PenjualanResponseModel>> updatePenjualan(int id, PenjualanRequestModel request) async {
    try {
      final response = await httpClient.put('penjualanbuah/$id', request.toMap());
      if (response.statusCode == 200) {
        return Right(PenjualanResponseModel.fromJson(response.body));
      } else {
        final error = json.decode(response.body);
        return Left(error['message'] ?? 'Gagal memperbarui data');
      }
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }

  Future<Either<String, bool>> deletePenjualan(int id) async {
    try {
      final response = await httpClient.delete('penjualanbuah/$id');
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
