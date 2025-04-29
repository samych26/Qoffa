class UserModel {
  final String id;
  final String email;
  final String typeUtilisateur; // client ou commerçant

  UserModel({
    required this.id,
    required this.email,
    required this.typeUtilisateur,
  });

  factory UserModel.fromMap(String id, Map<String, dynamic> data) {
    return UserModel(
      id: id,
      email: data['email'] ?? '',
      typeUtilisateur: data['typeUtilisateur'] ?? '',
    );
  }
}
