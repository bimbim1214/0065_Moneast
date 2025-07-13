import 'dart:convert';

class PembelianRequestModel {
    final int? supplierId;
    final int? buahId;
    final int? jumlah;
    final int? harga;
    final DateTime? tanggal;

    PembelianRequestModel({
        this.supplierId,
        this.buahId,
        this.jumlah,
        this.harga,
        this.tanggal,
    });

    factory PembelianRequestModel.fromJson(String str) => PembelianRequestModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory PembelianRequestModel.fromMap(Map<String, dynamic> json) => PembelianRequestModel(
        supplierId: json["supplier_id"],
        buahId: json["buah_id"],
        jumlah: json["jumlah"],
        harga: json["harga"],
        tanggal: json["tanggal"] == null ? null : DateTime.parse(json["tanggal"]),
    );

    Map<String, dynamic> toMap() => {
        "supplier_id": supplierId,
        "buah_id": buahId,
        "jumlah": jumlah,
        "harga": harga,
        "tanggal": "${tanggal!.year.toString().padLeft(4, '0')}-${tanggal!.month.toString().padLeft(2, '0')}-${tanggal!.day.toString().padLeft(2, '0')}",
    };
}
