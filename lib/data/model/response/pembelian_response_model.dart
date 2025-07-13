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

    PembelianResponseModel({
        this.id,
        this.buahId,
        this.supplierId,
        this.jumlah,
        this.harga,
        this.tanggal,
        this.namaBuah,
        this.namaSupplier,
    });

    factory PembelianResponseModel.fromJson(String str) => PembelianResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory PembelianResponseModel.fromMap(Map<String, dynamic> json) => PembelianResponseModel(
        id: json["id"],
        buahId: json["buah_id"],
        supplierId: json["supplier_id"],
        jumlah: json["jumlah"],
        harga: json["harga"],
        tanggal: json["tanggal"] == null ? null : DateTime.parse(json["tanggal"]),
        namaBuah: json["nama_buah"],
        namaSupplier: json["nama_supplier"],
    );

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
