class UserModel {
  final String name;
  final String email;
  final String namaToko;
  final String noTelepon;

  UserModel({
    required this.name,
    required this.email,
    required this.namaToko,
    required this.noTelepon,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['nama'],
      email: json['email'],
      namaToko: json['nama_toko'],
      noTelepon: json['no_telepon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama': name,
      'email': email,
      'nama_toko': namaToko,
      'no_telepon': noTelepon,
    };
  }
}
