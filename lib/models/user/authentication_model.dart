class AuthenticationModel {
  AuthenticationModel({
    required this.email,
    required this.name,
    required this.password,
    required this.role,
    required this.telpNumber,
  });
  final String email;
  final String name;
  final String password;
  final String role;
  final String telpNumber;

  factory AuthenticationModel.fromJson(Map<String, dynamic> authJSON) =>
      AuthenticationModel(
        email: authJSON["email"],
        name: authJSON["name"],
        password: authJSON["password"],
        role: authJSON["role"],
        telpNumber: authJSON["telp_number"],
      );
}
