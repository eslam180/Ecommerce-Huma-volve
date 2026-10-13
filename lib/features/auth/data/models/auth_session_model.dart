import '../../domain/entities/auth_session.dart';

class AuthSessionModel extends AuthSession {
  const AuthSessionModel({required super.accessToken});

  factory AuthSessionModel.fromJson(Map<String, dynamic> json) {
    final token = json['access_token'] ?? json['accessToken'] ?? json['token'];
    if (token is! String || token.isEmpty) {
      throw const FormatException('The API did not return an access token.');
    }
    return AuthSessionModel(accessToken: token);
  }
}
