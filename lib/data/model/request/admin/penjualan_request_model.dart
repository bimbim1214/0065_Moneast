import 'dart:convert';

class PenjualanRequestModel {
    final int? buahId;
    final int? jumlah;
    final int? harga;
    final DateTime? tanggal;

    PenjualanRequestModel({
        this.buahId,
        this.jumlah,
        this.harga,
        this.tanggal,
    });

    factory PenjualanRequestModel.fromJson(String str) => PenjualanRequestModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory PenjualanRequestModel.fromMap(Map<String, dynamic> json) => PenjualanRequestModel(
        buahId: json["buah_id"],
        jumlah: json["jumlah"],
        harga: json["harga"],
        tanggal: json["tanggal"] == null ? null : DateTime.parse(json["tanggal"]),
    );

    Map<String, dynamic> toMap() => {
        "buah_id": buahId,
        "jumlah": jumlah,
        "harga": harga,
        "tanggal": "${tanggal!.year.toString().padLeft(4, '0')}-${tanggal!.month.toString().padLeft(2, '0')}-${tanggal!.day.toString().padLeft(2, '0')}",
    };
}
