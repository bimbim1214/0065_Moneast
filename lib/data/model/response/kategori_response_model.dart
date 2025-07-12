import 'dart:convert';

class KategoriResponseModel {
    final String? namaKategori;
    final int? id;

    KategoriResponseModel({
        this.namaKategori,
        this.id,
    });

    factory KategoriResponseModel.fromJson(String str) => KategoriResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory KategoriResponseModel.fromMap(Map<String, dynamic> json) => KategoriResponseModel(
        namaKategori: json["nama_kategori"],
        id: json["id"],
    );

    Map<String, dynamic> toMap() => {
        "nama_kategori": namaKategori,
        "id": id,
    };
}
