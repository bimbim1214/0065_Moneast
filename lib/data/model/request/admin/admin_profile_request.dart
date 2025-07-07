import 'dart:convert';

class AdminProfileRequest {
    final String? name;

    AdminProfileRequest({
        this.name,
    });

    factory AdminProfileRequest.fromJson(String str) => AdminProfileRequest.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory AdminProfileRequest.fromMap(Map<String, dynamic> json) => AdminProfileRequest(
        name: json["name"],
    );

    Map<String, dynamic> toMap() => {
        "name": name,
    };
}
