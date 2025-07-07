class LoginResponseModel {
  final String message;
  final int statusCode;
  final DataUser data;

  LoginResponseModel({
    required this.message,
    required this.statusCode,
    required this.data,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      message: json['message'],
      statusCode: json['status_code'],
      data: DataUser.fromJson(json['data']),
    );
  }
}

class DataUser {
  final int id;
  final String name;
  final String email;
  final String role;
  final String token;

  DataUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.token,
  });

  factory DataUser.fromJson(Map<String, dynamic> json) {
    return DataUser(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      token: json['token'],
    );
  }
}
