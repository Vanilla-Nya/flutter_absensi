class AuthenticationModel {
  AuthenticationModel({
    required this.username,
    required this.password,
  });
  final String username;
  final String password;

  factory AuthenticationModel.fromJson(Map<String, dynamic> authJSON) =>
      AuthenticationModel(
        username: authJSON["email"],
        password: authJSON["password"],
      );
}
