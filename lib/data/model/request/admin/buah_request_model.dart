import 'dart:convert';

class BuahRequestModel {
    final String? nama;
    final int? stok;

    BuahRequestModel({
        this.nama,
        this.stok,
    });

    factory BuahRequestModel.fromJson(String str) => BuahRequestModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory BuahRequestModel.fromMap(Map<String, dynamic> json) => BuahRequestModel(
        nama: json["nama"],
        stok: json["stok"],
    );

    Map<String, dynamic> toMap() => {
        "nama": nama,
        "stok": stok,
    };
}
