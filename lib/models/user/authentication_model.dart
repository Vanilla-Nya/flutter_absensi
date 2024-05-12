class AuthenticationModel {
  AuthenticationModel({
    required this.username,
    required this.name,
    required this.password,
  });
  final String username;
  final String name;
  final String password;

  factory AuthenticationModel.fromJson(Map<String, dynamic> authJSON) =>
      AuthenticationModel(
        username: authJSON["email"],
        name: authJSON["name"],
        password: authJSON["password"],
      );
}
