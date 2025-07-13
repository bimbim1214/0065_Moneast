import 'dart:convert';

class BuahResponsesModel {
    final String? nama;
    final int? stok;
    final int? kategoriBuahId;
    final int? id;

    BuahResponsesModel({
        this.nama,
        this.stok,
        this.kategoriBuahId,
        this.id,
    });

    factory BuahResponsesModel.fromJson(String str) => BuahResponsesModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory BuahResponsesModel.fromMap(Map<String, dynamic> json) => BuahResponsesModel(
        nama: json["nama"],
        stok: json["stok"],
        kategoriBuahId: json["kategori_buah_id"],
        id: json["id"],
    );

    Map<String, dynamic> toMap() => {
        "nama": nama,
        "stok": stok,
        "kategori_buah_id": kategoriBuahId,
        "id": id,
    };
}
