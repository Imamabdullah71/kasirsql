class UserModel {
  final int id;
  final String name;
  final String email;
  final String? password;
  final String? namaToko;
  final String? alamat;
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
    this.alamat,
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
      alamat: json['alamat'],
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
      'alamat': alamat,
      'logo': logo,
      'no_telepon': noTelepon,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? password,
    String? namaToko,
    String? alamat,
    String? logo,
    String? noTelepon,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      namaToko: namaToko ?? this.namaToko,
      alamat: alamat ?? this.alamat,
      logo: logo ?? this.logo,
      noTelepon: noTelepon ?? this.noTelepon,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
