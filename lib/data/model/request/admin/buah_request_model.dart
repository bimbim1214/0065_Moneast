import 'dart:convert';

class BuahRequestModel {
    final String? nama;
    final int? stok;
    final int? kategoriBuahId;

    BuahRequestModel({
        this.nama,
        this.stok,
        this.kategoriBuahId,
    });

    factory BuahRequestModel.fromJson(String str) => BuahRequestModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory BuahRequestModel.fromMap(Map<String, dynamic> json) => BuahRequestModel(
        nama: json["nama"],
        stok: json["stok"],
        kategoriBuahId: json["kategori_buah_id"],
    );

    Map<String, dynamic> toMap() => {
        "nama": nama,
        "stok": stok,
        "kategori_buah_id": kategoriBuahId,
    };
}
