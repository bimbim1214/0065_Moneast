import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:pamfix/data/model/request/admin/supplier_request_model.dart';
import 'package:pamfix/data/model/response/supplier_response_model.dart';
import 'package:pamfix/services/service_http_client.dart';

class SupplierRepository {
  final ServiceHttpClient httpClient;

  SupplierRepository(this.httpClient);

  // Ambil semua supplier (GET /api/suppliers)
  Future<Either<String, List<SupplierResponsesModel>>> getAllSupplier() async {
    try {
      final response = await httpClient.get('suppliers');
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        final data = jsonList.map((e) => SupplierResponsesModel.fromMap(e)).toList();
        return Right(data);
      } else {
        final error = json.decode(response.body);
        return Left(error['message'] ?? 'Gagal mengambil data supplier');
      }
    } catch (e) {
      return Left('Kesalahan saat mengambil supplier: $e');
    }
  }

  // Tambah supplier (POST /api/suppliers)
  Future<Either<String, SupplierResponsesModel>> addSupplier(SupplierRequestModel request) async {
    try {
      final response = await httpClient.postWithToken('suppliers', request.toMap());

      if (response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        return Right(SupplierResponsesModel.fromMap(jsonData));
      } else {
        final error = json.decode(response.body);
        return Left(error['message'] ?? 'Gagal menambah supplier');
      }
    } catch (e) {
      return Left('Kesalahan saat menambah supplier: $e');
    }
  }

  // Edit supplier (PUT /api/suppliers/{id})
  Future<Either<String, SupplierResponsesModel>> updateSupplier(
    int id,
    SupplierRequestModel request,
  ) async {
    try {
      final response = await httpClient.put(
        'suppliers/$id',
        request.toMap(),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return Right(SupplierResponsesModel.fromMap(jsonData));
      } else {
        final error = json.decode(response.body);
        return Left(error['message'] ?? 'Gagal mengupdate supplier');
      }
    } catch (e) {
      return Left('Kesalahan saat update supplier: $e');
    }
  }

  // Hapus supplier (DELETE /api/suppliers/{id})
  Future<Either<String, bool>> deleteSupplier(int id) async {
    try {
      final response = await httpClient.delete('suppliers/$id');
      if (response.statusCode == 200) {
        return const Right(true);
      } else {
        final error = json.decode(response.body);
        return Left(error['message'] ?? 'Gagal menghapus supplier');
      }
    } catch (e) {
      return Left('Kesalahan saat menghapus supplier: $e');
    }
  }

  // Ambil detail supplier by ID (GET /api/suppliers/{id})
  Future<Either<String, SupplierResponsesModel>> getSupplierById(int id) async {
    try {
      final response = await httpClient.get('suppliers/$id');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return Right(SupplierResponsesModel.fromMap(jsonData));
      } else {
        final error = json.decode(response.body);
        return Left(error['message'] ?? 'Data tidak ditemukan');
      }
    } catch (e) {
      return Left('Kesalahan saat ambil supplier: $e');
    }
  }
}
