import 'dart:convert';

class PembelianResponseModel {
    final int? id;
    final int? buahId;
    final int? supplierId;
    final int? jumlah;
    final int? harga;
    final DateTime? tanggal;
    final String? namaBuah;
    final String? namaSupplier;

    // Local field, tidak dari backend
  final int total;


    PembelianResponseModel({
        this.id,
        this.buahId,
        this.supplierId,
        this.jumlah,
        this.harga,
        this.tanggal,
        this.namaBuah,
        this.namaSupplier,
        required this.total,
    });

    factory PembelianResponseModel.fromJson(String str) => PembelianResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory PembelianResponseModel.fromMap(Map<String, dynamic> json) {
    final jumlah = json['jumlah'] ?? 0;
    final harga = json['harga'] ?? 0;
    return PembelianResponseModel(
      id: json['id'],
      buahId: json['buah_id'],
      namaBuah: json['nama_buah'],
      supplierId: json['supplier_id'],
      namaSupplier: json['nama_supplier'],
      jumlah: jumlah,
      harga: harga,
      tanggal: json["tanggal"] == null ? null : DateTime.parse(json["tanggal"]),
      total: jumlah * harga, // hitung total langsung di sini
    );
  }

    Map<String, dynamic> toMap() => {
        "id": id,
        "buah_id": buahId,
        "supplier_id": supplierId,
        "jumlah": jumlah,
        "harga": harga,
        "tanggal": "${tanggal!.year.toString().padLeft(4, '0')}-${tanggal!.month.toString().padLeft(2, '0')}-${tanggal!.day.toString().padLeft(2, '0')}",
        "nama_buah": namaBuah,
        "nama_supplier": namaSupplier,
    };
    
}
