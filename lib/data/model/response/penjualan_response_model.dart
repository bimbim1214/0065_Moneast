import 'dart:convert';

class PenjualanResponseModel {
    final int? buahId;
    final int? jumlah;
    final int? harga;
    final DateTime? tanggal;
    final int? totalHarga;
    final int? id;

    PenjualanResponseModel({
        this.buahId,
        this.jumlah,
        this.harga,
        this.tanggal,
        this.totalHarga,
        this.id,
    });

    factory PenjualanResponseModel.fromJson(String str) => PenjualanResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory PenjualanResponseModel.fromMap(Map<String, dynamic> json) => PenjualanResponseModel(
        buahId: json["buah_id"],
        jumlah: json["jumlah"],
        harga: json["harga"],
        tanggal: json["tanggal"] == null ? null : DateTime.parse(json["tanggal"]),
        totalHarga: json["total_harga"],
        id: json["id"],
    );

    Map<String, dynamic> toMap() => {
        "buah_id": buahId,
        "jumlah": jumlah,
        "harga": harga,
        "tanggal": "${tanggal!.year.toString().padLeft(4, '0')}-${tanggal!.month.toString().padLeft(2, '0')}-${tanggal!.day.toString().padLeft(2, '0')}",
        "total_harga": totalHarga,
        "id": id,
    };
}
