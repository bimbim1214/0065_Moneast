import 'dart:convert';

class SupplierRequestModel {
    final String? nama;
    final String? alamat;
    final String? telepon;
    final int? jumlah;
    final int? buahId;

    SupplierRequestModel({
        this.nama,
        this.alamat,
        this.telepon,
        this.jumlah,
        this.buahId,
    });

    factory SupplierRequestModel.fromJson(String str) => SupplierRequestModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory SupplierRequestModel.fromMap(Map<String, dynamic> json) => SupplierRequestModel(
        nama: json["nama"],
        alamat: json["alamat"],
        telepon: json["telepon"],
        jumlah: json["jumlah"],
        buahId: json["buah_id"],
    );

    Map<String, dynamic> toMap() => {
        "nama": nama,
        "alamat": alamat,
        "telepon": telepon,
        "jumlah": jumlah,
        "buah_id": buahId,
    };
}
