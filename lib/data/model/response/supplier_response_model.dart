import 'dart:convert';

class SupplierResponsesModel {
    final String? nama;
    final String? alamat;
    final String? telepon;
    final int? jumlah;
    final int? buahId;
    final String? keterangan;
    final int? id;

    SupplierResponsesModel({
        this.nama,
        this.alamat,
        this.telepon,
        this.jumlah,
        this.buahId,
        this.keterangan,
        this.id,
    });

    factory SupplierResponsesModel.fromJson(String str) => SupplierResponsesModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory SupplierResponsesModel.fromMap(Map<String, dynamic> json) => SupplierResponsesModel(
        nama: json["nama"],
        alamat: json["alamat"],
        telepon: json["telepon"],
        jumlah: json["jumlah"],
        buahId: json["buah_id"],
        keterangan: json["keterangan"],
        id: json["id"],
    );

    Map<String, dynamic> toMap() => {
        "nama": nama,
        "alamat": alamat,
        "telepon": telepon,
        "jumlah": jumlah,
        "buah_id": buahId,
        "keterangan": keterangan,
        "id": id,
    };
}
