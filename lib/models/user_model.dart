class UserModel {
  final int id;
  final String name;
  final String email;
  final String? password;
  final String? namaToko;
  final String? logo;
  final String? noTelepon;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.password,
    this.namaToko,
    this.logo,
    this.noTelepon,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is String ? int.parse(json['id']) : json['id'] ?? 0,
      name: json['nama'] ?? '',
      email: json['email'] ?? '',
      password: json['password'],
      namaToko: json['nama_toko'],
      logo: json['logo'],
      noTelepon: json['no_telepon'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': name,
      'email': email,
      'password': password,
      'nama_toko': namaToko,
      'logo': logo,
      'no_telepon': noTelepon,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
