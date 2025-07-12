import 'dart:convert';

class BuahResponseModel {
    final String? nama;
    final int? stok;
    final DateTime? updatedAt;
    final DateTime? createdAt;
    final int? id;

    BuahResponseModel({
        this.nama,
        this.stok,
        this.updatedAt,
        this.createdAt,
        this.id,
    });

    factory BuahResponseModel.fromJson(String str) => BuahResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory BuahResponseModel.fromMap(Map<String, dynamic> json) => BuahResponseModel(
        nama: json["nama"],
        stok: json["stok"],
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        id: json["id"],
    );

    Map<String, dynamic> toMap() => {
        "nama": nama,
        "stok": stok,
        "updated_at": updatedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "id": id,
    };
}
