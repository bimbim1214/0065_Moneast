import 'dart:convert';

class KategoriRequestModel {
    final String? namaKategori;

    KategoriRequestModel({
        this.namaKategori,
    });

    factory KategoriRequestModel.fromJson(String str) => KategoriRequestModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory KategoriRequestModel.fromMap(Map<String, dynamic> json) => KategoriRequestModel(
        namaKategori: json["nama_kategori"],
    );

    Map<String, dynamic> toMap() => {
        "nama_kategori": namaKategori,
    };
}
